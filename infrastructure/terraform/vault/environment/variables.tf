variable "consul_endpoint" {
  type = string
}

variable "consul_ca_file" {
  type = string
}

variable "consul_token" {
  type      = string
  sensitive = true
}
