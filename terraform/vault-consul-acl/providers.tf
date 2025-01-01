provider "vault" {
  address      = format("%v://%v", var.vault_scheme, var.vault_address)
  token        = var.vault_token
  ca_cert_file = var.vault_ca_file
}

provider "consul" {
  address = var.consul_address
  scheme  = var.consul_scheme
  ca_file = var.consul_ca_file
  token   = var.consul_token
}
