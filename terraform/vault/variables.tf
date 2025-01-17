variable "consul_address" {
  type    = string
  default = "172.16.1.1:8501"
}

variable "consul_scheme" {
  type    = string
  default = "https"
}

variable "consul_ca_file" {
  type    = string
  default = "../../ansible/secrets/pki/ca/consul/ca.pem"
}

variable "consul_token" {
  type      = string
  sensitive = true
}

variable "consul_remote_address" {
  type    = string
  default = "127.0.0.1:8401"
}

variable "consul_remote_scheme" {
  type    = string
  default = "https"
}

variable "vault_address" {
  type    = string
  default = "172.16.1.1:8200"
}

variable "vault_scheme" {
  type    = string
  default = "https"
}

variable "vault_ca_file" {
  type    = string
  default = "../../ansible/secrets/pki/ca/vault/ca.pem"
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "nomad_address" {
  type    = string
  default = "172.16.1.1:8200"
}

variable "nomad_scheme" {
  type    = string
  default = "https"
}

variable "nomad_ca_file" {
  type    = string
  default = "../../ansible/secrets/pki/ca/nomad/ca.pem"
}

variable "nomad_token" {
  type      = string
  sensitive = true
}

variable "nomad_remote_address" {
  type    = string
  default = "127.0.0.1:4546"
}

variable "nomad_remote_scheme" {
  type    = string
  default = "https"
}
