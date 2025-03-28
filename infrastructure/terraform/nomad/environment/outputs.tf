output "nomad_client_consul_token" {
  value     = data.consul_acl_token_secret_id.nomad_client.secret_id
  sensitive = true
}

output "nomad_server_consul_token" {
  value     = data.consul_acl_token_secret_id.nomad_server.secret_id
  sensitive = true
}
