resource "vault_consul_secret_backend" "consul" {
  address = var.consul_remote_address
  scheme  = "https"
  ca_cert = file(var.consul_ca_file)
  token   = var.consul_token
}

resource "vault_nomad_secret_backend" "nomad" {
  address = format("https://%v", var.nomad_remote_address)
  ca_cert = file(var.nomad_ca_file)
  token   = var.nomad_token
}

resource "vault_mount" "nomad_workload" {
  type = "kv"
  path = var.vault_kv_nomad_workload_path

  description = "KV storage for Nomad Workloads"

  options = {
    version = 2
  }
}

resource "consul_acl_policy" "consul_agent" {
  name  = "consul-agent"
  rules = file("${path.module}/policies/consul/consul-agent.hcl")
}

resource "consul_acl_policy" "consul_dns" {
  name  = "consul-dns"
  rules = file("${path.module}/policies/consul/consul-dns.hcl")
}

resource "consul_acl_policy" "nomad_client" {
  name  = "nomad-client"
  rules = file("${path.module}/policies/consul/nomad-client.hcl")
}

resource "consul_acl_policy" "nomad_server" {
  name  = "nomad-server"
  rules = file("${path.module}/policies/consul/nomad-server.hcl")
}

resource "vault_policy" "vault_agent" {
  name = "vault-agent"
  policy = templatefile("${path.module}/policies/vault/vault-agent.hcl.tftpl", {
    consul_mount_path      = vault_consul_secret_backend.consul.path
    consul_agent_role_name = vault_consul_secret_backend_role.consul_agent.name
    consul_dns_role_name   = vault_consul_secret_backend_role.consul_dns.name
    nomad_server_role_name = vault_consul_secret_backend_role.nomad_server.name
    nomad_client_role_name = vault_consul_secret_backend_role.nomad_client.name
  })
}

resource "vault_policy" "nomad_workload" {
  name = "nomad-workload"
  policy = templatefile("${path.module}/policies/vault/nomad-workload.hcl.tftpl", {
    kv_mount_path        = vault_mount.nomad_workload.path
    database_mount_path  = var.vault_database_path
    auth_method_accessor = vault_jwt_auth_backend.nomad.accessor
  })
}

resource "vault_jwt_auth_backend" "nomad" {
  path         = "jwt-nomad"
  jwks_url     = var.nomad_remote_jwks_url
  jwks_ca_pem  = file(var.nomad_ca_file)
  default_role = "nomad-workload"
}

resource "vault_jwt_auth_backend_role" "nomad_workload" {
  backend = vault_jwt_auth_backend.nomad.path

  role_type = "jwt"
  role_name = vault_jwt_auth_backend.nomad.default_role

  token_type      = "service"
  token_policies  = [vault_policy.nomad_workload.name]
  bound_audiences = ["vault.io"]

  token_period           = 1800
  token_explicit_max_ttl = 0

  user_claim              = "/nomad_job_id"
  user_claim_json_pointer = true
  claim_mappings = {
    nomad_task      = "nomad_task"
    nomad_job_id    = "nomad_job_id",
    nomad_namespace = "nomad_namespace",
  }
}

resource "vault_auth_backend" "approle" {
  type = "approle"
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

resource "vault_consul_secret_backend_role" "consul_agent" {
  name            = "consul-agent"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.consul_agent.name]
}

resource "vault_consul_secret_backend_role" "consul_dns" {
  name            = "consul-dns"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.consul_dns.name]
}

resource "vault_consul_secret_backend_role" "nomad_server" {
  name            = "nomad-server"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.nomad_server.name]
}

resource "vault_consul_secret_backend_role" "nomad_client" {
  name            = "nomad-client"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.nomad_client.name]
}
