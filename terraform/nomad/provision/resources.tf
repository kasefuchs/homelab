resource "consul_acl_auth_method" "nomad_workloads" {
  name        = "nomad-workloads"
  type        = "jwt"
  description = "JWT-based ACL authentication method for Nomad workloads."
  config_json = jsonencode({
    JWKSURL          = "https://nomad.service.consul:4646/.well-known/jwks.json"
    JWKSCACert       = var.vault_pki_intermediate_ca_certificate
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
  bind_type   = "service"
  bind_name   = "$${value.nomad_service}"
  selector    = "\"nomad_service\" in value"
}
