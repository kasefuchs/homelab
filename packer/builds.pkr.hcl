build {
  sources = ["vagrant.image", "docker.image"]

  provisioner "ansible" {
    playbook_file    = "${local.ansible_directory}/playbooks/packer.yaml"
    extra_arguments  = concat(var.ansible.extra_arguments, ["--scp-extra-args", "'-O'"])
    ansible_env_vars = concat(var.ansible.env_vars, ["ANSIBLE_CONFIG=${local.ansible_directory}/ansible.cfg"])
  }

  post-processors {
    post-processor "docker-tag" {
      only = ["docker.image"]

      tags       = var.docker.result_image_tags
      repository = var.docker.result_image_repository
    }
  }
}
