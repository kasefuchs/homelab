provider "vault" {
  address      = format("https://%v", var.vault_address)
  ca_cert_file = var.vault_ca_file
  token        = var.vault_token
}

provider "postgresql" {
  host     = var.postgresql_host
  port     = var.postgresql_port
  username = var.postgresql_username
  password = var.postgresql_password
  sslmode  = "disable"
}
