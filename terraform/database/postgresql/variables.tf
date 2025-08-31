variable "connection_name" {
  type    = string
  default = "default-postgresql"
}

variable "static_roles" {
  type = list(object({
    vault_role          = string
    postgresql_role     = string
    postgresql_database = string
  }))
  default = []
}
