variable "postgresql_role_name" {
  type = string
}

variable "postgresql_database_name" {
  type = string
}

variable "vault_role_name" {
  type = string
}

variable "vault_backend_name" {
  type = string
}

variable "vault_connection_name" {
  type = string
}

variable "vault_rotation_period" {
  type    = number
  default = 86400
}
