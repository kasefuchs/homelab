resource "consul_acl_policy" "vault_service" {
  name  = "vault-service"
  rules = file("${path.module}/policies/consul/vault-service.hcl")
}

resource "consul_acl_token" "vault_service" {
  policies = [consul_acl_policy.vault_service.name]
}
