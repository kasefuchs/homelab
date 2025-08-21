locals {
  root_certificate_ttl         = provider::time::duration_parse("87600h").seconds # 10 years.
  intermediate_certificate_ttl = provider::time::duration_parse("43800h").seconds # 5 years.
}

locals {
  vault_kv_cluster_mount_path       = "kv-cluster"
  vault_pki_root_mount_path         = "pki-root"
  vault_pki_intermediate_mount_path = "pki-intermediate"
}
