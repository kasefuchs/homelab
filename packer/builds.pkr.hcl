build {
  sources = ["vagrant.image"]

  provisioner "ansible" {
    playbook_file    = "${local.ansible_directory}/playbooks/packer.yaml"
    extra_arguments  = concat(var.ansible.extra_arguments, ["--scp-extra-args", "'-O'"])
    ansible_env_vars = concat(var.ansible.env_vars, ["ANSIBLE_CONFIG=${local.ansible_directory}/ansible.cfg"])
  }
}
