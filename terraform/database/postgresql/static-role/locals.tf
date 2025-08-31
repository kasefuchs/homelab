locals {
  role_rotation_period = provider::time::duration_parse("24h").seconds # 1 day.
}

locals {
  vault_db_nomad_mount_path = "db-nomad"
}
