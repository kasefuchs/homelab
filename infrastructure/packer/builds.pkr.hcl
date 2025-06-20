build {
  sources = ["vagrant.image"]

  provisioner "ansible" {
    playbook_file    = "${local.ansible_directory}/playbooks/packer.yaml"
    ansible_env_vars = ["ANSIBLE_CONFIG=${local.ansible_directory}/ansible.cfg"]
  }
}
