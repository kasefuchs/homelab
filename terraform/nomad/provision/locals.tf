locals {
  intermediate_certificate_ttl = provider::time::duration_parse("43800h").seconds # 5 years.
}

locals {
  vault_pki_root_mount_path  = "pki-root"
  vault_kv_nomad_mount_path  = "kv-nomad"
  vault_db_nomad_mount_path  = "db-nomad"
  vault_pki_nomad_mount_path = "pki-nomad"
}
