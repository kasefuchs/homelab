variable "consul_endpoint" {
  type = string
}

variable "consul_ca_file" {
  type = string
}

variable "consul_token" {
  type      = string
  sensitive = true
}

variable "vault_endpoint" {
  type = string
}

variable "vault_ca_file" {
  type = string
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "nomad_endpoint" {
  type = string
}

variable "nomad_ca_file" {
  type = string
}

variable "nomad_token" {
  type      = string
  sensitive = true
}

variable "nomad_jwks_url" {
  type = string
}

variable "consul_nomad_jwt_auth_method" {
  type = string
}

variable "vault_nomad_jwt_auth_backend" {
  type = string
}
