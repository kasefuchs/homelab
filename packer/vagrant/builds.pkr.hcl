build {
  sources = ["vagrant.centos"]

  provisioner "ansible" {
    playbook_file    = "../../ansible/playbooks/bootstrap.yml"
    ansible_env_vars = ["ANSIBLE_CONFIG=../../ansible/ansible.cfg"]
  }
}
