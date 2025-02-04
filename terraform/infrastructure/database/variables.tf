variable "postgresql_host" {
  type    = string
  default = "172.16.1.1"
}

variable "postgresql_port" {
  type    = number
  default = 5432
}

variable "postgresql_remote_host" {
  type    = string
  default = "172.16.1.1"
}

variable "postgresql_remote_port" {
  type    = number
  default = 5432
}

variable "postgresql_username" {
  type    = string
  default = "postgres"
}

variable "postgresql_password" {
  type      = string
  sensitive = true
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

variable "vault_database_path" {
  type    = string
  default = "database"
}

variable "vault_postgresql_username" {
  type    = string
  default = "vault"
}

variable "vault_postgresql_database" {
  type    = string
  default = "vault"
}

variable "vault_postgresql_roles" {
  type = list(
    object({
      role_name     = string
      user_name     = string
      database_name = string
    })
  )
  default = []
}
