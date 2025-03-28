output "consul_agent_consul_token" {
  value     = data.consul_acl_token_secret_id.consul_agent.secret_id
  sensitive = true
}

output "consul_dns_consul_token" {
  value     = data.consul_acl_token_secret_id.consul_dns.secret_id
  sensitive = true
}
