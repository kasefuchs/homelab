resource "postgresql_role" "user" {
  name  = var.postgresql_user_name
  login = true
}

resource "postgresql_database" "database" {
  name  = var.postgresql_database_name
  owner = postgresql_role.user.name
}

resource "vault_database_secret_backend_static_role" "role" {
  name            = var.vault_role_name
  backend         = var.vault_backend_name
  db_name         = var.vault_connection_name
  username        = postgresql_role.user.name
  rotation_period = var.vault_rotation_period

  rotation_statements = ["ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';"]
}
