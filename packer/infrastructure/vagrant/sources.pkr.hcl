source "vagrant" "box" {
  communicator = "ssh"

  source_path = var.vagrant_source_path
  provider    = var.vagrant_provider
  skip_add    = var.vagrant_skip_add
}
