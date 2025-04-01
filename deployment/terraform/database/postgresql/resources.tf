resource "random_password" "vault" {
  length = 18
}

resource "postgresql_role" "vault" {
  name     = "vault"
  password = random_password.vault.result

  login     = true
  superuser = true
}

resource "postgresql_database" "vault" {
  name  = "vault"
  owner = postgresql_role.vault.name
}

resource "vault_database_secret_backend_connection" "postgresql" {
  name          = var.vault_connection_name
  backend       = var.vault_database_path
  allowed_roles = ["*"]

  postgresql {
    username       = postgresql_role.vault.name
    password       = postgresql_role.vault.password
    connection_url = "postgresql://{{username}}:{{password}}@${var.postgresql_balancer_endpoint}/${postgresql_database.vault.name}"
  }
}
