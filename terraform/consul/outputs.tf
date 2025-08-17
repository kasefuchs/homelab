output "consul_acl_agent_token_secret_id" {
  value     = data.consul_acl_token_secret_id.consul_agent.secret_id
  sensitive = true
}

output "consul_acl_dns_token_secret_id" {
  value     = data.consul_acl_token_secret_id.consul_dns.secret_id
  sensitive = true
}
