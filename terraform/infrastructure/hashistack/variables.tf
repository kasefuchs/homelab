variable "consul_address" {
  type    = string
  default = "172.16.1.1:8501"
}

variable "consul_ca_file" {
  type    = string
  default = "../../../ansible/secrets/testing/pki/ca/consul/ca.crt"
}

variable "consul_token" {
  type      = string
  sensitive = true
}

variable "consul_remote_address" {
  type    = string
  default = "127.0.0.1:8501"
}

variable "vault_address" {
  type    = string
  default = "172.16.1.1:8200"
}

variable "vault_ca_file" {
  type    = string
  default = "../../../ansible/secrets/testing/pki/ca/vault/ca.crt"
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "nomad_address" {
  type    = string
  default = "172.16.1.1:8200"
}

variable "nomad_ca_file" {
  type    = string
  default = "../../../ansible/secrets/testing/pki/ca/nomad/ca.crt"
}

variable "nomad_token" {
  type      = string
  sensitive = true
}

variable "nomad_remote_address" {
  type    = string
  default = "127.0.0.1:4546"
}

variable "nomad_remote_jwks_url" {
  type    = string
  default = "https://127.0.0.1:4546/.well-known/jwks.json"
}

variable "vault_kv_nomad_workload_path" {
  type    = string
  default = "nomad-workload"
}

variable "vault_database_path" {
  type    = string
  default = "database"
}
