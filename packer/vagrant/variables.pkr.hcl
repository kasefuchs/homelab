variable "centos_source_path" {
  type    = string
  default = "centos/stream9"
}

variable "centos_provider" {
  type    = string
  default = "virtualbox"
}

variable "centos_skip_add" {
  type    = bool
  default = true
}
