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
      # Upgrade packages.
      "sudo apt-get -y update",
      "sudo apt-get -y upgrade",
      # Install commons.
      "sudo apt-get -y install apt-transport-https bash build-essential ca-certificates curl fish git gnupg htop jq lsb-release nano rclone rsync sudo tree unzip wget zsh",
      # Cleanup.
      "sudo apt-get -y autoremove",
      "sudo apt-get -y clean"
    ]
  }
}
