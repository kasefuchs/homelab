build {
  sources = ["vagrant.box"]

  provisioner "ansible" {
    playbook_file    = var.ansible_playbook_file
    extra_arguments  = var.ansible_extra_arguments
    ansible_env_vars = var.ansible_env_vars
  }
}
