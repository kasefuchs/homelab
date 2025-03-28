resource "consul_acl_policy" "nomad_client" {
  name  = "nomad-client"
  rules = file("${path.module}/policies/consul/nomad-client.hcl")
}

resource "consul_acl_token" "nomad_client" {
  policies = [consul_acl_policy.nomad_client.name]
}

resource "consul_acl_policy" "nomad_server" {
  name  = "nomad-server"
  rules = file("${path.module}/policies/consul/nomad-server.hcl")
}

resource "consul_acl_token" "nomad_server" {
  policies = [consul_acl_policy.nomad_client.name]
}
