source "docker" "this" {
  image  = var.docker_source_image
  commit = true
}

source "yandex" "this" {
  # Placement parameters.
  zone        = var.yandex_zone
  token       = var.yandex_token
  folder_id   = var.yandex_folder_id
  preemptible = var.yandex_preemptible

  # Network parameters
  subnet_id    = var.yandex_subnet_id
  ssh_username = var.yandex_ssh_username
  use_ipv4_nat = true

  # Boot disk parameters.
  disk_type       = var.yandex_disk_type
  disk_size_gb    = var.yandex_disk_size
  source_image_id = var.yandex_source_image

  # Result image parameters.
  image_name        = var.yandex_result_image_name
  image_description = "Coder workspace image based on ${var.yandex_source_image}."
}

build {
  sources = [
    "source.docker.this",
    "source.yandex.this"
  ]

  # Install sudo in non-sudo environments.
  provisioner "shell" {
    only = ["docker.this"]

    inline = [
      # Update already installed packages.
      "apt-get -y update",
      "apt-get -y upgrade",

      # Install sudo.
      "apt-get -y install sudo",
    ]

    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  # Update already installed packages.
  provisioner "shell" {
    # This is not necessary as we have already updated everything above.
    except = ["docker.this"]

    inline = [
      "sudo -E apt-get -y update",
      "sudo -E apt-get -y upgrade",
    ]

    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  # Install new packages.
  provisioner "shell" {
    inline = [
      # Install VNC utilities.
      "sudo -E apt-get -y install novnc python3-websockify tigervnc-standalone-server",

      # Install desktop environment components.
      "sudo -E apt-get -y install dbus-x11 lightdm xfce4 xorg",

      # Install common apps.
      "sudo -E apt-get -y install firefox-esr xfce4-terminal",
    ]

    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  provisioner "shell" {
    inline = [
      # Link vnc.html to index.html so that the noVNC interface opens at /.
      "sudo ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html",
    ]
  }

  # Remove apt caches to reduce layer size.
  provisioner "shell" {
    inline = [
      "sudo -E apt-get -y autoremove",
      "sudo -E apt-get -y clean"
    ]

    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      only = ["docker.this"]

      repository = var.docker_result_image_repository
      tags       = var.docker_result_image_tags
    }

    post-processor "docker-push" {
      only = ["docker.this"]

      login          = var.docker_login
      login_server   = var.docker_login_server
      login_username = var.docker_login_username
      login_password = var.docker_login_password
    }
  }
}
