variable "consul_endpoint" {
  type    = string
  default = "172.16.1.1:8501"
}

variable "consul_ca_file" {
  type    = string
  default = "/etc/consul/pki/ca.crt"
}

variable "consul_token" {
  type      = string
  sensitive = true
}
