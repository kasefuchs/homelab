# Common
variable "install_packages" {
  type = list(list(string))
  default = [
    ["apt-transport-https", "ca-certificates", "software-properties-common", "supervisor"],
    ["bash", "curl", "fish", "git", "gpg", "jq", "nano", "rsync", "wget", "zsh"]
  ]
}

variable "coder_access_url" {
  type    = string
  default = "https://dev.coder.com/"
}

# Docker
variable "docker_source_image" {
  type    = string
  default = "debian:bookworm"
}

variable "docker_result_image_repository" {
  type    = string
  default = "ghcr.io/kasefuchs/coder-workspace"
}

variable "docker_result_image_tags" {
  type    = list(string)
  default = ["minimal"]
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
