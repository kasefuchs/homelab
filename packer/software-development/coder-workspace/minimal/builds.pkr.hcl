build {
  sources = ["docker.minimal"]

  # Install sudo in non-sudo environments.
  provisioner "shell" {
    only = ["docker.minimal"]

    inline = [
      # Update already installed packages.
      "apt --yes update",
      "apt --yes upgrade",

      # Install sudo.
      "apt --yes install sudo",
    ]

    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
  }

  # Update already installed packages.
  provisioner "shell" {
    # This is not necessary as we have already updated everything above.
    except = ["docker.minimal"]

    inline = [
      "sudo --preserve-env apt --yes update",
      "sudo --preserve-env apt --yes upgrade",
    ]

    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
  }

  # Install packages.
  dynamic "provisioner" {
    labels   = ["shell"]
    for_each = var.install_packages

    content {
      inline = [
        format("sudo --preserve-env apt install --yes %s", join(" ", provisioner.value))
      ]

      env = {
        DEBIAN_FRONTEND = "noninteractive"
      }
    }
  }

  # Remove apt caches to reduce image size.
  provisioner "shell" {
    inline = [
      "sudo --preserve-env apt --yes autoremove",
      "sudo --preserve-env apt --yes clean"
    ]

    env = {
      DEBIAN_FRONTEND = "noninteractive"
    }
  }

  # Install Coder binary.
  provisioner "shell" {
    script          = "scripts/install-coder.sh"
    execute_command = "chmod +x {{ .Path }}; sudo {{ .Vars }} {{ .Path }}"

    env = {
      ACCESS_URL = var.coder_access_url
    }
  }

  # Copy rootfs.
  provisioner "file" {
    source      = "rootfs/"
    destination = "/tmp/rootfs"
  }

  # Merge rootfs.
  provisioner "shell" {
    inline = [
      "sudo rsync -a /tmp/rootfs/ /",
      "sudo rm -rf /tmp/rootfs/"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      only = ["docker.minimal"]

      repository = var.docker_result_image_repository
      tags       = var.docker_result_image_tags
    }

    post-processor "docker-push" {
      only = ["docker.minimal"]

      login          = var.docker_login
      login_server   = var.docker_login_server
      login_username = var.docker_login_username
      login_password = var.docker_login_password
    }
  }
}
