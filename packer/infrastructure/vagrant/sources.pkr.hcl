source "vagrant" "box" {
  communicator = "ssh"

  source_path = var.source_path
  provider    = var.provider
  skip_add    = var.skip_add
}
