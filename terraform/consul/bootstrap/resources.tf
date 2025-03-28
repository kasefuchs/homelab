resource "consul_acl_policy" "consul_agent" {
  name  = "consul-agent"
  rules = file("${path.module}/policies/consul/consul-agent.hcl")
}

resource "consul_acl_token" "consul_agent" {
  policies = [consul_acl_policy.consul_agent.name]
}

resource "consul_acl_policy" "consul_dns" {
  name  = "consul-dns"
  rules = file("${path.module}/policies/consul/consul-dns.hcl")
}

resource "consul_acl_token" "consul_dns" {
  policies = [consul_acl_policy.consul_dns.name]
}

