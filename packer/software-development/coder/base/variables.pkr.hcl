### Docker
variable "docker_source_image" {
  type    = string
  default = "debian:bookworm"
}

variable "docker_result_image_repository" {
  type = string
}

variable "docker_result_image_tags" {
  type    = list(string)
  default = ["base"]
}

variable "docker_login" {
  type    = bool
  default = true
}

variable "docker_login_server" {
  type    = string
  default = "ghcr.io"
}

variable "docker_login_username" {
  type = string
}

variable "docker_login_password" {
  type      = string
  sensitive = true
}

### Yandex Compute
variable "yandex_zone" {
  type    = string
  default = "ru-central1-d"
}

variable "yandex_token" {
  type      = string
  sensitive = true
}

variable "yandex_folder_id" {
  type = string
}

variable "yandex_preemptible" {
  type    = bool
  default = true
}

variable "yandex_subnet_id" {
  type = string
}

variable "yandex_disk_type" {
  type    = string
  default = "network-ssd"
}

variable "yandex_disk_size" {
  type    = number
  default = 5
}

variable "yandex_ssh_username" {
  type    = string
  default = "debian"
}

variable "yandex_source_image" {
  type    = string
  default = "fd8efe8vd78f8p7kidgf"
}

variable "yandex_result_image_name" {
  type    = string
  default = "coder-workspace-base-{{ timestamp }}"
}
