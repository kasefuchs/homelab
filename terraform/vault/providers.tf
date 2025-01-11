provider "vault" {
  address      = format("%v://%v", var.vault_scheme, var.vault_address)
  ca_cert_file = var.vault_ca_file
  token        = var.vault_token
}

provider "consul" {
  address = var.consul_address
  scheme  = var.consul_scheme
  ca_file = var.consul_ca_file
  token   = var.consul_token
}

provider "nomad" {
  address   = format("%v://%v", var.nomad_scheme, var.nomad_address)
  ca_file   = var.nomad_ca_file
  secret_id = var.nomad_token
}
