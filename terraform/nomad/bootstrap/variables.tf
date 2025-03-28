variable "consul_endpoint" {
  type    = string
  default = "127.0.0.1:8501"
}

variable "consul_ca_file" {
  type    = string
  default = "../../../ansible/secrets/testing/pki/ca/consul/ca.crt"
}

variable "consul_token" {
  type      = string
  sensitive = true
}

variable "vault_endpoint" {
  type    = string
  default = "active.vault.service.consul:8200"
}

variable "vault_ca_file" {
  type    = string
  default = "../../../ansible/secrets/testing/pki/ca/vault/ca.crt"
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "nomad_endpoint" {
  type    = string
  default = "nomad.service.consul:4646"
}

variable "nomad_ca_file" {
  type    = string
  default = "../../../ansible/secrets/testing/pki/ca/nomad/ca.crt"
}

variable "nomad_token" {
  type      = string
  sensitive = true
}

variable "nomad_jwks_url" {
  type    = string
  default = "https://nomad.service.consul:4646/.well-known/jwks.json"
}

variable "vault_kv_nomad_workload_path" {
  type    = string
  default = "nomad-workload"
}
