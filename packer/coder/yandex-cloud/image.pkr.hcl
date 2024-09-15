source "yandex" "coder" {
  zone      = var.yandex_availability_zone
  token     = var.yandex_token
  folder_id = var.yandex_folder_id
  subnet_id = var.yandex_subnet_id

  preemptible  = true
  use_ipv4_nat = true

  ssh_username            = "debian"
  temporary_key_pair_type = "ed25519"

  image_name          = var.yandex_image_name
  image_family        = var.yandex_image_family
  image_description   = "Coder workspace image based on ${var.yandex_source_image_family}."
  source_image_family = var.yandex_source_image_family
}

build {
  sources = ["source.yandex.coder"]

  provisioner "shell" {
    inline = [
      # Upgrade packages.
      "sudo apt-get -y update",
      "sudo apt-get -y upgrade",
      # Install common tools.
      "sudo apt-get -y install apt-transport-https bash build-essential ca-certificates chromium curl fish git gnupg htop jq lsb-release rclone rsync tree unzip wget zsh",
      # Install development tools.
      "sudo apt-get -y install golang micro python3 python3-pip vim",
      # Cleanup.
      "sudo apt-get -y autoremove",
      "sudo apt-get -y clean"
    ]
  }
}
