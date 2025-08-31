resource "random_password" "vault" {
  length = 18
}

resource "postgresql_role" "vault" {
  name      = "vault"
  password  = random_password.vault.result
  login     = true
  superuser = true
}

resource "postgresql_database" "vault" {
  name  = "vault"
  owner = postgresql_role.vault.name
}

resource "vault_database_secret_backend_connection" "postgresql" {
  name          = var.connection_name
  backend       = local.vault_db_nomad_mount_path
  allowed_roles = ["*"]

  postgresql {
    username       = postgresql_role.vault.name
    password       = postgresql_role.vault.password
    tls_ca         = data.vault_pki_secret_backend_issuer.nomad.certificate
    connection_url = "postgresql://{{username}}:{{password}}@postgresql.service.consul:5432/${postgresql_database.vault.name}?sslmode=verify-full"
  }
}
