resource "vault_consul_secret_backend" "consul" {
  path    = "consul"
  address = var.consul_remote_address
  scheme  = var.consul_remote_scheme
  ca_cert = file(var.consul_ca_file)
  token   = var.consul_token
}
