data "consul_acl_token_secret_id" "vault_service" {
  accessor_id = consul_acl_token.vault_service.accessor_id
}
