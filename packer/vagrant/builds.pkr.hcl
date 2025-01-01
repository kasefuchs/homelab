build {
  sources = [
    "vagrant.centos",
    "vagrant.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file    = "../../ansible/playbooks/bootstrap.yml"
    extra_arguments  = ["--scp-extra-args", "'-O'"]
    ansible_env_vars = ["ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
  }
}
