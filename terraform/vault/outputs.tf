output "vault_agent_auto_auth_method_role_id" {
  value = vault_approle_auth_backend_role.agent.role_id
}

output "vault_agent_auto_auth_method_secret_id" {
  value = nonsensitive(vault_approle_auth_backend_role_secret_id.agent.secret_id)
}
