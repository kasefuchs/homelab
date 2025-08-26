output "vault_agent_auth_role_id" {
  value = vault_approle_auth_backend_role.vault_agent.role_id
}

output "vault_agent_auth_role_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.vault_agent.secret_id
  sensitive = true
}

output "vault_pki_root_ca_certificate" {
  value = vault_pki_secret_backend_root_cert.root.certificate
}

output "vault_pki_cluster_ca_certificate" {
  value = vault_pki_secret_backend_root_sign_intermediate.cluster.certificate
}
