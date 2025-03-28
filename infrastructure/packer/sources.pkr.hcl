source "vagrant" "box" {
  communicator = "ssh"
  template     = "templates/Vagrantfile.tpl"

  skip_add    = var.vagrant_skip_add
  source_path = var.vagrant_source_path
}
