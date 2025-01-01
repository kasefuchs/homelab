source "vagrant" "centos" {
  communicator = "ssh"

  source_path = var.centos_source_path
  provider    = var.centos_provider
  skip_add    = var.centos_skip_add
}

source "vagrant" "ubuntu" {
  communicator = "ssh"

  source_path = var.ubuntu_source_path
  provider    = var.ubuntu_provider
  skip_add    = var.ubuntu_skip_add
}
