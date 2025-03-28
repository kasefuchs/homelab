output "vault_service_consul_token" {
  value     = data.consul_acl_token_secret_id.vault_service.secret_id
  sensitive = true
}
