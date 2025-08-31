data "vault_pki_secret_backend_issuer" "nomad" {
  backend    = local.vault_pki_nomad_mount_path
  issuer_ref = "default"
}
