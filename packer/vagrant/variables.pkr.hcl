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

variable "ubuntu_source_path" {
  type    = string
  default = "ubuntu/jammy64"
}

variable "ubuntu_provider" {
  type    = string
  default = "virtualbox"
}

variable "ubuntu_skip_add" {
  type    = bool
  default = true
}
