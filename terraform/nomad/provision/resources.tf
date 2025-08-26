resource "consul_acl_auth_method" "nomad_workloads" {
  name        = "nomad-workloads"
  type        = "jwt"
  description = "JWT auth method for Nomad services and workloads"
  config_json = jsonencode({
    JWKSURL          = "https://nomad.service.consul:4646/.well-known/jwks.json"
    JWKSCACert       = var.vault_pki_cluster_ca_certificate
    JWTSupportedAlgs = ["RS256"]
    BoundAudiences   = ["consul.io"]
    ClaimMappings = {
      nomad_namespace = "nomad_namespace"
      nomad_job_id    = "nomad_job_id"
      nomad_task      = "nomad_task"
      nomad_service   = "nomad_service"
    }
  })
}

resource "consul_acl_binding_rule" "nomad_service" {
  auth_method = consul_acl_auth_method.nomad_workloads.name
  description = "Binding rule for services registered from Nomad"
  bind_type   = "service"
  bind_name   = "$${value.nomad_service}"
  selector    = "\"nomad_service\" in value"
}

resource "consul_acl_policy" "nomad_tasks" {
  name        = "nomad-tasks"
  rules       = file("${path.module}/policies/consul/nomad-tasks.hcl")
  description = "A policy that is used by Nomad tasks"
}

resource "consul_acl_role" "nomad_tasks_default" {
  name        = "nomad-tasks-default"
  policies    = [consul_acl_policy.nomad_tasks.name]
  description = "ACL role for Nomad tasks in the default Nomad namespace"
}

resource "consul_acl_binding_rule" "nomad_role" {
  auth_method = consul_acl_auth_method.nomad_workloads.name
  description = "Binding rule for Nomad tasks"
  bind_type   = "role"
  bind_name   = "nomad-tasks-$${value.nomad_namespace}"
  selector    = "\"nomad_service\" not in value"
}

resource "vault_jwt_auth_backend" "nomad" {
  path         = "jwt-nomad"
  default_role = "nomad-workloads"

  jwks_url           = "https://nomad.service.consul:4646/.well-known/jwks.json"
  jwks_ca_pem        = var.vault_pki_cluster_ca_certificate
  jwt_supported_algs = ["RS256", "EdDSA"]
}

resource "vault_mount" "kv_nomad" {
  type        = "kv"
  path        = local.vault_kv_nomad_mount_path
  options     = { version = "2" }
  description = "kv engine for nomad tasks"
}

resource "vault_mount" "db_nomad" {
  type        = "database"
  path        = local.vault_db_nomad_mount_path
  description = "database engine for nomad tasks"
}

resource "vault_policy" "nomad_workloads" {
  name = "nomad-workloads"
  policy = templatefile("${path.module}/policies/vault/nomad-workloads.hcl.tftpl", {
    auth_backend_accessor = vault_jwt_auth_backend.nomad.accessor
    kv_nomad_mount_path   = vault_mount.kv_nomad.path
    db_nomad_mount_path   = vault_mount.db_nomad.path
  })
}

resource "vault_jwt_auth_backend_role" "nomad_workloads" {
  backend = vault_jwt_auth_backend.nomad.path

  role_type = "jwt"
  role_name = vault_jwt_auth_backend.nomad.default_role

  token_type      = "service"
  token_policies  = [vault_policy.nomad_workloads.name]
  bound_audiences = ["vault.io"]

  token_period           = 1800
  token_explicit_max_ttl = 0

  user_claim              = "/nomad_job_id"
  user_claim_json_pointer = true
  claim_mappings = {
    nomad_task      = "nomad_task"
    nomad_job_id    = "nomad_job_id"
    nomad_namespace = "nomad_namespace"
  }
}
