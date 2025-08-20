resource "consul_acl_policy" "consul_agent" {
  name  = "consul-agent"
  rules = file("${path.module}/policies/consul-agent.hcl")
}

resource "consul_acl_token" "consul_agent" {
  policies = [consul_acl_policy.consul_agent.name]
}

resource "consul_acl_policy" "consul_dns" {
  name  = "consul-dns"
  rules = file("${path.module}/policies/consul-dns.hcl")
}

resource "consul_acl_token" "consul_dns" {
  policies = [consul_acl_policy.consul_dns.name]
}

resource "consul_acl_policy" "nomad_client" {
  name  = "nomad-client"
  rules = file("${path.module}/policies/nomad-client.hcl")
}

resource "consul_acl_token" "nomad_client" {
  policies = [consul_acl_policy.nomad_client.name]
}

resource "consul_acl_policy" "nomad_server" {
  name  = "nomad-server"
  rules = file("${path.module}/policies/nomad-server.hcl")
}

resource "consul_acl_token" "nomad_server" {
  policies = [consul_acl_policy.nomad_server.name]
}
