# Vault secret backends.
resource "vault_consul_secret_backend" "consul" {
  address = var.consul_remote_address
  scheme  = var.consul_remote_scheme
  ca_cert = file(var.consul_ca_file)
  token   = var.consul_token
}

resource "vault_nomad_secret_backend" "nomad" {
  address = format("%v://%v", var.nomad_remote_scheme, var.nomad_remote_address)
  ca_cert = file(var.nomad_ca_file)
  token   = var.nomad_token
}

# Vault auth backends.
resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "agent" {
  backend   = vault_auth_backend.approle.path
  role_name = "agent"
  token_policies = [
    vault_policy.consul_dns.name
  ]
}

resource "vault_approle_auth_backend_role_secret_id" "agent" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.agent.role_name
}

# Consul policies.
resource "consul_acl_policy" "dns" {
  name  = "dns"
  rules = file("${path.module}/policies/consul/dns.hcl")
}

# Vault policies.
resource "vault_policy" "consul_dns" {
  name   = "consul-dns"
  policy = file("${path.module}/policies/vault/consul-dns.hcl")
}

# Vault Consul secret backend roles.
resource "vault_consul_secret_backend_role" "dns" {
  name    = "dns"
  backend = vault_consul_secret_backend.consul.path
  consul_policies = [
    consul_acl_policy.dns.name
  ]
}
