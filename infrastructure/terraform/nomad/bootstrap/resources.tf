resource "vault_mount" "nomad_kv" {
  type = "kv"
  path = var.vault_nomad_kv_mount
  options = {
    version = 2
  }
}

resource "vault_mount" "nomad_db" {
  type = "database"
  path = var.vault_nomad_db_mount
}

resource "consul_acl_policy" "nomad_tasks" {
  name  = "nomad-tasks"
  rules = file("${path.module}/policies/consul/nomad-tasks.hcl")
}

resource "consul_acl_auth_method" "nomad" {
  type = "jwt"
  name = var.consul_nomad_jwt_auth_method
  config_json = jsonencode({
    JWKSURL          = var.nomad_jwks_url
    JWKSCACert       = file(var.nomad_ca_file)
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
  auth_method = consul_acl_auth_method.nomad.name
  bind_type   = "service"
  bind_name   = "$${value.nomad_service}"
  selector    = "\"nomad_service\" in value"
}

resource "consul_acl_binding_rule" "nomad_role" {
  auth_method = consul_acl_auth_method.nomad.name
  bind_type   = "role"
  bind_name   = "nomad-tasks-$${value.nomad_namespace}"
  selector    = "\"nomad_service\" not in value"
}

resource "consul_acl_role" "nomad_tasks_default" {
  name     = "nomad-tasks-default"
  policies = [consul_acl_policy.nomad_tasks.name]
}

resource "vault_policy" "nomad_workload" {
  name = "nomad-workload"
  policy = templatefile("${path.module}/policies/vault/nomad-workload.hcl.tftpl", {
    kv_mount_path         = vault_mount.nomad_kv.path
    db_mount_path         = vault_mount.nomad_db.path
    auth_backend_accessor = vault_jwt_auth_backend.nomad.accessor
  })
}

resource "vault_jwt_auth_backend" "nomad" {
  path               = var.vault_nomad_jwt_auth_backend
  jwks_url           = var.nomad_jwks_url
  jwks_ca_pem        = file(var.nomad_ca_file)
  jwt_supported_algs = ["RS256", "EdDSA"]
  default_role       = "nomad-workload"
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
    nomad_job_id    = "nomad_job_id"
    nomad_namespace = "nomad_namespace"
  }
}
