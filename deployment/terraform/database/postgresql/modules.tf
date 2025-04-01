module "static-role" {
  source = "./modules/static-role"

  vault_backend_name    = var.vault_database_path
  vault_connection_name = vault_database_secret_backend_connection.postgresql.name

  vault_role_name          = each.value.vault_role
  postgresql_role_name     = each.value.postgresql_role
  postgresql_database_name = each.value.postgresql_database

  for_each = {
    for index, role in var.vault_postgresql_static_roles :
    role.vault_role => role
  }
}
