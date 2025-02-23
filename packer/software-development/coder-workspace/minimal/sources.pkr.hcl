source "docker" "minimal" {
  image  = var.docker_source_image
  commit = true
}
