variable "vagrant" {
  type = object({
    provider        = string
    source_path     = string
    source_skip_add = bool
  })

  default = {
    provider        = "libvirt"
    source_path     = "generic/debian12"
    source_skip_add = true
  }
}

variable "docker" {
  type = object({
    source_image_build = object({
      path      = string
      arguments = map(string)
    })
    result_image_tags       = list(string)
    result_image_repository = string
  })

  default = {
    source_image_build = {
      path      = "../docker/Dockerfile.debian"
      arguments = { "DISTRO_TAG" : "bookworm-slim" }
    }
    result_image_tags       = ["bookworm-slim"]
    result_image_repository = "ghcr.io/kasefuchs/homelab-debian"
  }
}

variable "ansible" {
  type = object({
    env_vars        = list(string)
    extra_arguments = list(string)
  })

  default = {
    env_vars        = []
    extra_arguments = ["--tags", "download,install"]
  }
}
