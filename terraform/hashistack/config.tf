terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }

    consul = {
      source = "hashicorp/consul"
    }

    nomad = {
      source = "hashicorp/nomad"
    }
  }
}
