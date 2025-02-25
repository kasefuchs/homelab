variable "source_path" {
  type    = string
  default = "centos/stream9"
}

variable "provider" {
  type    = string
  default = "virtualbox"
}

variable "skip_add" {
  type    = bool
  default = true
}
