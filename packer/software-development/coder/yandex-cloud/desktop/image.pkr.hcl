source "yandex" "coder" {
  zone      = var.availability_zone
  token     = var.token
  folder_id = var.folder_id
  subnet_id = var.subnet_id

  preemptible  = true
  use_ipv4_nat = true
  ssh_username = var.ssh_username

  disk_type    = var.disk_type
  disk_size_gb = var.disk_size

  image_name        = var.image_name
  source_image_id   = var.source_image_id
  image_description = "Coder workspace image based on ${var.source_image_id}."
}

build {
  sources = ["source.yandex.coder"]

  provisioner "shell" {
    inline = [
      # Update packages cache.
      "sudo apt-get -y update",
      # Install VNC.
      "sudo apt-get -y install novnc python3-websockify tigervnc-standalone-server",
      "sudo ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html",
      # Install DE.
      "sudo apt-get -y install dbus-x11 lightdm xfce4 xorg",
      # Install apps.
      "sudo apt-get -y install firefox-esr xfce4-terminal",
      # Cleanup.
      "sudo apt-get -y autoremove",
      "sudo apt-get -y clean"
    ]
  }
}
