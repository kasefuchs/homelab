variable "vagrant_source_path" {
  type    = string
  default = "centos/stream9"
}

variable "vagrant_provider" {
  type    = string
  default = "virtualbox"
}

variable "vagrant_skip_add" {
  type    = bool
  default = true
}

variable "ansible_playbook_file" {
  type    = string
  default = "../../../ansible/playbooks/vagrant.yml"
}

variable "ansible_extra_arguments" {
  type = list(string)
  default = [
    "--tags", "system,install",
    "--scp-extra-args", "'-O'",
  ]
}

variable "ansible_env_vars" {
  type    = list(string)
  default = ["ANSIBLE_CONFIG=../../../ansible/ansible.cfg"]
}
