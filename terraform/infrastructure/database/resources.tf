resource "random_password" "vault" {
  length = 20
}

resource "postgresql_role" "vault" {
  name     = var.vault_postgresql_username
  password = random_password.vault.result

  login     = true
  superuser = true
}

resource "postgresql_database" "vault" {
  name  = var.vault_postgresql_database
  owner = postgresql_role.vault.name
}

resource "vault_mount" "database" {
  type = "database"
  path = var.vault_database_path

  description = "database secrets engine"
}

resource "vault_database_secret_backend_connection" "postgresql" {
  name          = "postgresql"
  backend       = vault_mount.database.path
  allowed_roles = ["*"]

  postgresql {
    username       = postgresql_role.vault.name
    password       = postgresql_role.vault.password
    connection_url = "postgresql://{{username}}:{{password}}@${var.postgresql_remote_host}:${var.postgresql_remote_port}/${postgresql_database.vault.name}"
  }
}
