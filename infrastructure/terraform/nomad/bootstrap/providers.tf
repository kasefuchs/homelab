provider "vault" {
  address      = format("https://%v", var.vault_endpoint)
  ca_cert_file = var.vault_ca_file
  token        = var.vault_token
}

provider "consul" {
  address = var.consul_endpoint
  scheme  = "https"
  ca_file = var.consul_ca_file
  token   = var.consul_token
}

provider "nomad" {
  address   = format("https://%v", var.nomad_endpoint)
  ca_file   = var.nomad_ca_file
  secret_id = var.nomad_token
}
