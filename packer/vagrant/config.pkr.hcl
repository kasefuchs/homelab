packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/ansible"
    }

    vagrant = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}
