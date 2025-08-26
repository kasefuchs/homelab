resource "consul_acl_policy" "nomad_client" {
  name        = "nomad-client"
  rules       = file("${path.module}/policies/consul/nomad-client.hcl")
  description = "A policy that is used by Nomad clients"
}

resource "consul_acl_token" "nomad_client" {
  policies = [consul_acl_policy.nomad_client.name]
}

resource "consul_acl_policy" "nomad_server" {
  name        = "nomad-server"
  rules       = file("${path.module}/policies/consul/nomad-server.hcl")
  description = "A policy that is used by Nomad servers"
}

resource "consul_acl_token" "nomad_server" {
  policies = [consul_acl_policy.nomad_server.name]
}

resource "random_bytes" "nomad_encrypt" { length = 32 }

resource "vault_kv_secret_v2" "nomad" {
  name  = "nomad"
  mount = local.vault_kv_cluster_mount_path
  data_json = jsonencode({
    encrypt             = random_bytes.nomad_encrypt.base64
    server_consul_token = data.consul_acl_token_secret_id.nomad_server.secret_id
    client_consul_token = data.consul_acl_token_secret_id.nomad_client.secret_id
  })
}

resource "vault_pki_secret_backend_role" "consul" {
  backend          = local.vault_pki_intermediate_mount_path
  name             = "nomad"
  allowed_domains  = ["nomad", "service.consul", "internal"]
  allow_subdomains = true
}
