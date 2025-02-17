source "docker" "base" {
  image  = var.docker_source_image
  commit = true
}
