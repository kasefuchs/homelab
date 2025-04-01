variable "postgresql_host" {
  type    = string
  default = "172.16.1.1"
}

variable "postgresql_port" {
  type    = number
  default = 5432
}

variable "postgresql_balancer_endpoint" {
  type    = string
  default = "172.16.1.1:5432"
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
  default = "../../../../infrastructure/ansible/.secrets/production/vault/pki/ca/ca.crt"
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "vault_database_path" {
  type    = string
  default = "nomad-db"
}

variable "vault_connection_name" {
  type    = string
  default = "default-postgresql"
}

variable "vault_postgresql_static_roles" {
  type = list(
    object({
      vault_role          = string
      postgresql_role     = string
      postgresql_database = string
    })
  )
  default = []
}
