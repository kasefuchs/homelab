variable "vagrant_skip_add" {
  type    = bool
  default = true
}

variable "vagrant_source_path" {
  type    = string
  default = "generic/debian12"
}

variable "ansible_env_vars" {
  type    = list(string)
  default = ["ANSIBLE_CONFIG=../ansible/ansible.cfg"]
}

variable "ansible_playbook_file" {
  type    = string
  default = "../ansible/playbooks/vagrant.yml"
}

variable "ansible_extra_arguments" {
  type = list(string)
  default = [
    "--tags", "install,common",
    "--scp-extra-args", "'-O'",
  ]
}
