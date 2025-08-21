resource "random_bytes" "consul_encrypt" { length = 32 }

resource "vault_kv_secret_v2" "consul" {
  name      = "consul"
  mount     = local.vault_kv_cluster_mount_path
  data_json = jsonencode({ encrypt = random_bytes.consul_encrypt.base64 })
}

resource "vault_pki_secret_backend_role" "consul" {
  backend          = local.vault_pki_intermediate_mount_path
  name             = "consul"
  allowed_domains  = ["consul", "internal"]
  allow_subdomains = true
}
