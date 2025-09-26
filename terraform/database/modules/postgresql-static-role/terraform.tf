terraform {
  required_providers {
    time       = { source = "hashicorp/time" }
    vault      = { source = "hashicorp/vault" }
    postgresql = { source = "cyrilgdn/postgresql" }
  }
}
