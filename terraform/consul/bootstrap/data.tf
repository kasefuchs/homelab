data "consul_acl_token_secret_id" "consul_agent" {
  accessor_id = consul_acl_token.consul_agent.accessor_id
}

data "consul_acl_token_secret_id" "consul_dns" {
  accessor_id = consul_acl_token.consul_dns.accessor_id
}
