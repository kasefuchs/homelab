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
    changes = list(string)
    source_image_build = object({
      path      = string
      pull      = bool
      arguments = map(string)
    })
    result_image_tags       = list(string)
    result_image_repository = string
  })

  default = {
    changes = [
      "ENV PEBBLE /var/lib/pebble/",
      "ENTRYPOINT [\"sh\"]",
      "CMD [\"-c\", \"/usr/local/bin/dockerd-entrypoint.sh & until docker info >/dev/null 2>&1; do sleep 1; done && /usr/local/bin/pebble-entrypoint.sh\"]"
    ]
    source_image_build = {
      path      = "../docker/Dockerfile.debian"
      pull      = true
      arguments = { "DISTRO_TAG" : "trixie-slim" }
    }
    result_image_tags       = ["trixie-slim"]
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
    extra_arguments = ["--tags=packer"]
  }
}
