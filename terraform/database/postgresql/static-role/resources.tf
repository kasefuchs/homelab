resource "postgresql_role" "role" {
  name  = var.postgresql_role_name
  login = true
}

resource "postgresql_database" "database" {
  name  = var.postgresql_database_name
  owner = postgresql_role.role.name
}

resource "vault_database_secret_backend_static_role" "role" {
  name     = var.vault_role_name
  backend  = local.vault_db_nomad_mount_path
  db_name  = var.vault_connection_name
  username = postgresql_role.role.name

  rotation_period     = local.role_rotation_period
  rotation_statements = ["ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';"]
}
