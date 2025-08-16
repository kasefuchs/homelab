source "vagrant" "image" {
  communicator = "ssh"

  template    = "${local.template_directory}/vagrant/Vagrantfile.${var.vagrant.provider}.tpl"
  provider    = var.vagrant.provider
  skip_add    = var.vagrant.source_skip_add
  output_dir  = "${local.output_directory}/vagrant/${var.vagrant.provider}"
  source_path = var.vagrant.source_path
}

source "docker" "image" {
  commit  = true
  changes = var.docker.changes

  build {
    path      = var.docker.source_image_build.path
    pull      = var.docker.source_image_build.pull
    arguments = var.docker.source_image_build.arguments
  }
}
