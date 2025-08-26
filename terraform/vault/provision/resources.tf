resource "vault_mount" "kv_cluster" {
  type        = "kv"
  path        = local.vault_kv_cluster_mount_path
  options     = { version = "2" }
  description = "kv engine for cluster secrets and configuration"
}

resource "vault_mount" "pki_root" {
  type                  = "pki"
  path                  = local.vault_pki_root_mount_path
  description           = "root pki ca for signing intermediate authorities"
  max_lease_ttl_seconds = local.root_certificate_ttl
}

resource "vault_pki_secret_backend_config_urls" "root" {
  backend                 = vault_mount.pki_root.path
  issuing_certificates    = [format("https://server.vault:8200/v1/%s/ca", vault_mount.pki_root.path)]
  crl_distribution_points = [format("https://server.vault:8200/v1/%s/crl", vault_mount.pki_root.path)]
}

resource "vault_pki_secret_backend_root_cert" "root" {
  type        = "internal"
  backend     = vault_mount.pki_root.path
  common_name = "Vault PKI Root CA"
  ttl         = local.root_certificate_ttl
}

resource "vault_mount" "pki_cluster" {
  type        = "pki"
  path        = local.vault_pki_cluster_mount_path
  description = "intermediate pki ca for issuing cluster certificates"
}

resource "vault_pki_secret_backend_config_urls" "cluster" {
  backend                 = vault_mount.pki_cluster.path
  issuing_certificates    = [format("https://server.vault:8200/v1/%s/ca", vault_mount.pki_cluster.path)]
  crl_distribution_points = [format("https://server.vault:8200/v1/%s/crl", vault_mount.pki_cluster.path)]
}

resource "vault_pki_secret_backend_intermediate_cert_request" "cluster" {
  type        = "internal"
  backend     = vault_mount.pki_cluster.path
  common_name = "Vault PKI Cluster CA"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "cluster" {
  backend     = vault_mount.pki_root.path
  csr         = vault_pki_secret_backend_intermediate_cert_request.cluster.csr
  ttl         = local.intermediate_certificate_ttl
  common_name = "Vault PKI Cluster CA"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "cluster" {
  backend     = vault_mount.pki_cluster.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.cluster.certificate
}

resource "vault_policy" "vault_agent" {
  name = "vault-agent"
  policy = templatefile("${path.module}/policies/vault/vault-agent.hcl.tftpl", {
    kv_cluster_mount_path  = vault_mount.kv_cluster.path,
    pki_cluster_mount_path = vault_mount.pki_cluster.path,
  })
}

resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "approle"
}

resource "vault_approle_auth_backend_role" "vault_agent" {
  backend        = vault_auth_backend.approle.path
  role_name      = "vault-agent"
  token_policies = [vault_policy.vault_agent.name]
}

resource "vault_approle_auth_backend_role_secret_id" "vault_agent" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.vault_agent.role_name
}
