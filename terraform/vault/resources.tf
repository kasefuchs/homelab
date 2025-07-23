resource "vault_mount" "pki_root" {
  type                  = "pki"
  path                  = "pki-root"
  description           = "Root PKI"
  max_lease_ttl_seconds = provider::time::duration_parse("87600h").seconds
}

resource "vault_pki_secret_backend_config_urls" "pki_root" {
  backend                 = vault_mount.pki_root.path
  issuing_certificates    = [format("https://server.vault:8200/v1/%s/ca", vault_mount.pki_root.path)]
  crl_distribution_points = [format("https://server.vault:8200/v1/%s/crl", vault_mount.pki_root.path)]
}

resource "vault_pki_secret_backend_root_cert" "root" {
  backend     = vault_mount.pki_root.path
  type        = "internal"
  common_name = "Vault PKI Root CA"
  ttl         = provider::time::duration_parse("87600h").seconds
}

resource "vault_mount" "pki_intermediate" {
  type        = "pki"
  path        = "pki-intermediate"
  description = "Intermediate PKI"
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  backend     = vault_mount.pki_intermediate.path
  type        = "internal"
  common_name = "Vault PKI Intermediate CA"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  backend     = vault_mount.pki_root.path
  csr         = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  common_name = "Vault PKI Intermediate CA"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.pki_intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}
