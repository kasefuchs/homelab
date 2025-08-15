resource "vault_mount" "kv_cluster" {
  type        = "kv"
  path        = "kv-cluster"
  options     = { version = "2" }
  description = "Cluster KV"
}

resource "random_bytes" "consul_encrypt" {
  length = 32
}

resource "vault_kv_secret_v2" "consul" {
  name      = "consul"
  mount     = vault_mount.kv_cluster.path
  data_json = jsonencode({ encrypt = random_bytes.consul_encrypt.base64 })
}

resource "vault_mount" "pki_root" {
  type                  = "pki"
  path                  = "pki-root"
  description           = "Root PKI"
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

resource "vault_mount" "pki_intermediate" {
  type        = "pki"
  path        = "pki-intermediate"
  description = "Intermediate PKI"
}

resource "vault_pki_secret_backend_config_urls" "intermediate" {
  backend                 = vault_mount.pki_intermediate.path
  issuing_certificates    = [format("https://server.vault:8200/v1/%s/ca", vault_mount.pki_intermediate.path)]
  crl_distribution_points = [format("https://server.vault:8200/v1/%s/crl", vault_mount.pki_intermediate.path)]
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  type        = "internal"
  backend     = vault_mount.pki_intermediate.path
  common_name = "Vault PKI Intermediate CA"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  backend     = vault_mount.pki_root.path
  csr         = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  ttl         = local.intermediate_certificate_ttl
  common_name = "Vault PKI Intermediate CA"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.pki_intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}

resource "vault_pki_secret_backend_role" "consul" {
  backend          = vault_mount.pki_intermediate.path
  name             = "consul"
  allowed_domains  = ["consul", "internal"]
  allow_subdomains = true
}

resource "vault_policy" "vault_agent" {
  name = "vault-agent"
  policy = templatefile("${path.module}/policies/vault-agent.hcl.tftpl", {
    kv_cluster_mount_path       = vault_mount.kv_cluster.path,
    pki_intermediate_mount_path = vault_mount.pki_intermediate.path,
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
