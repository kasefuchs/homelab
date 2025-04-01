resource "random_password" "password" {
  length = 18
}

resource "postgresql_role" "role" {
  name     = var.postgresql_role_name
  password = random_password.password.result

  login           = true
  create_database = true
}

resource "postgresql_database" "database" {
  name  = var.postgresql_database_name
  owner = postgresql_role.role.name
}

resource "vault_database_secret_backend_static_role" "role" {
  name     = var.vault_role_name
  backend  = var.vault_backend_name
  db_name  = var.vault_connection_name
  username = postgresql_role.role.name

  rotation_period     = var.vault_rotation_period
  rotation_statements = ["ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';"]
}
