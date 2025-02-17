build {
  sources = ["docker.base"]

  # Install sudo in non-sudo environments.
  provisioner "shell" {
    only = ["docker.base"]

    inline = [
      # Update already installed packages.
      "apt --yes update",
      "apt --yes upgrade",

      # Install sudo.
      "apt --yes install sudo",
    ]

    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  # Update already installed packages.
  provisioner "shell" {
    # This is not necessary as we have already updated everything above.
    except = ["docker.base"]

    inline = [
      "sudo --preserve-env apt --yes update",
      "sudo --preserve-env apt --yes upgrade",
    ]

    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  # Install packages.
  dynamic "provisioner" {
    labels   = ["shell"]
    for_each = var.install_packages

    content {
      inline = [
        format("sudo --preserve-env apt install --yes %s", join(" ", provisioner.value))
      ]

      environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    }
  }

  # Remove apt caches to reduce image size.
  provisioner "shell" {
    inline = [
      "sudo --preserve-env apt --yes autoremove",
      "sudo --preserve-env apt --yes clean"
    ]

    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  provisioner "file" {
    source = "rootfs/"
    destination = "/"
  }

  post-processors {
    post-processor "docker-tag" {
      only = ["docker.base"]

      repository = var.docker_result_image_repository
      tags       = var.docker_result_image_tags
    }

    post-processor "docker-push" {
      only = ["docker.base"]

      login          = var.docker_login
      login_server   = var.docker_login_server
      login_username = var.docker_login_username
      login_password = var.docker_login_password
    }
  }
}
