terraform {
  required_providers {
    time   = { source = "hashicorp/time" }
    nomad  = { source = "hashicorp/nomad" }
    vault  = { source = "hashicorp/vault" }
    consul = { source = "hashicorp/consul" }
  }
}
