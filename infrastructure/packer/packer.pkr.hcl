packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1.5"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.3"
    }
  }
}
