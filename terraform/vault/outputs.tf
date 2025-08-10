output "vault_agent_auth_role_id" {
  value = vault_approle_auth_backend_role.vault_agent.role_id
}

output "vault_agent_auth_role_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.vault_agent.secret_id
  sensitive = true
}
