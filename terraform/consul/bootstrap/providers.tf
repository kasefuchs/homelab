provider "consul" {
  scheme = "https"

  ca_file = var.consul_ca_file
  address = var.consul_endpoint
  token   = var.consul_token
}
