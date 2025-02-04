terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }

    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
}
