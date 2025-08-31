terraform {
  required_providers {
    vault      = { source = "hashicorp/vault" }
    random     = { source = "hashicorp/random" }
    postgresql = { source = "cyrilgdn/postgresql" }
  }
}
