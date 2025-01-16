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

# Consul policies.
resource "consul_acl_policy" "dns" {
  name  = "dns"
  rules = file("${path.module}/policies/consul/dns.hcl")
}

resource "consul_acl_policy" "nomad_client" {
  name  = "nomad-client"
  rules = file("${path.module}/policies/consul/nomad-client.hcl")
}

resource "consul_acl_policy" "nomad_server" {
  name  = "nomad-server"
  rules = file("${path.module}/policies/consul/nomad-server.hcl")
}

# Vault policies.
resource "vault_policy" "agent" {
  name   = "agent"
  policy = file("${path.module}/policies/vault/agent.hcl")
}

# Vault auth backends.
resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "agent" {
  backend        = vault_auth_backend.approle.path
  role_name      = "agent"
  token_policies = [vault_policy.agent.name]
}

resource "vault_approle_auth_backend_role_secret_id" "agent" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.agent.role_name
}

resource "vault_consul_secret_backend_role" "dns" {
  name            = "dns"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.dns.name, ]
}

resource "vault_consul_secret_backend_role" "nomad_server" {
  name            = "nomad-server"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.nomad_server.name, ]
}

resource "vault_consul_secret_backend_role" "nomad_client" {
  name            = "nomad-client"
  backend         = vault_consul_secret_backend.consul.path
  consul_policies = [consul_acl_policy.nomad_client.name]
}
