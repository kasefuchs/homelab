packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.1.0"
    }

    yandex = {
      source  = "github.com/hashicorp/yandex"
      version = ">= 1.1.2"
    }
  }
}
