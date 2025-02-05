module "postgresql" {
  source                   = "./modules/postgresql"
  vault_backend_name       = vault_mount.database.path
  vault_connection_name    = vault_database_secret_backend_connection.postgresql.name
  vault_role_name          = each.value.role_name
  postgresql_database_name = each.value.database_name
  postgresql_user_name     = each.value.user_name

  for_each = {
    for index, role in var.vault_postgresql_roles :
    role.role_name => role
  }
}
