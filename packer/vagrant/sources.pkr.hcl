source "vagrant" "centos" {
  communicator = "ssh"

  source_path = var.centos_source_path
  provider    = var.centos_provider
  skip_add    = var.centos_skip_add
}
