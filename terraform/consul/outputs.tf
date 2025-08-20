output "consul_agent_acl_token_secret_id" {
  value     = data.consul_acl_token_secret_id.consul_agent.secret_id
  sensitive = true
}

output "consul_dns_acl_token_secret_id" {
  value     = data.consul_acl_token_secret_id.consul_dns.secret_id
  sensitive = true
}

output "nomad_client_acl_token_secret_id" {
  value     = data.consul_acl_token_secret_id.nomad_client.secret_id
  sensitive = true
}

output "nomad_server_acl_token_secret_id" {
  value     = data.consul_acl_token_secret_id.nomad_server.secret_id
  sensitive = true
}
