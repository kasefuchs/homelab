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
  name        = local.consul_nomad_tasks_acl_policy
  rules       = file("${path.module}/policies/consul/nomad-tasks.hcl")
  description = "A policy that is used by Nomad tasks"
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

resource "vault_mount" "pki_nomad" {
  type        = "pki"
  path        = local.vault_pki_nomad_mount_path
  description = "intermediate pki ca for issuing nomad tasks certificates"
}

resource "vault_pki_secret_backend_config_urls" "cluster" {
  backend                 = vault_mount.pki_nomad.path
  issuing_certificates    = [format("https://server.vault:8200/v1/%s/ca", vault_mount.pki_nomad.path)]
  crl_distribution_points = [format("https://server.vault:8200/v1/%s/crl", vault_mount.pki_nomad.path)]
}

resource "vault_pki_secret_backend_intermediate_cert_request" "cluster" {
  type        = "internal"
  backend     = vault_mount.pki_nomad.path
  common_name = "Vault PKI Nomad CA"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "cluster" {
  backend     = local.vault_pki_root_mount_path
  ttl         = local.intermediate_certificate_ttl
  csr         = vault_pki_secret_backend_intermediate_cert_request.cluster.csr
  common_name = vault_pki_secret_backend_intermediate_cert_request.cluster.common_name
}

resource "vault_pki_secret_backend_intermediate_set_signed" "cluster" {
  backend     = vault_mount.pki_nomad.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.cluster.certificate
}

resource "vault_policy" "nomad_workloads" {
  name = "nomad-workloads"
  policy = templatefile("${path.module}/policies/vault/nomad-workloads.hcl.tftpl", {
    auth_backend_accessor = vault_jwt_auth_backend.nomad.accessor
    kv_nomad_mount_path   = vault_mount.kv_nomad.path
    db_nomad_mount_path   = vault_mount.db_nomad.path
    pki_nomad_mount_path  = vault_mount.pki_nomad.path
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
