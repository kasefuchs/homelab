---
icon: material/map-check
title: Prerequisites
---

# :material-map-check: Prerequisites

## :material-remote-desktop: Controller-Node

A workstation that will be used to run infrastructure preparation tools.

The following software must be installed on it:

- **[Python](https://www.python.org/) &mdash;** Required for [**Ansible**](https://github.com/ansible/ansible) to work.
- **[VirtualBox](https://www.virtualbox.org/) &mdash;** Required to run virtual machines.
- **[Vagrant](https://www.vagrantup.com/) &mdash;** A tool for creating test nodes in virtual machines.
- **[Packer](https://www.packer.io/) &mdash;** A tool for automated building of virtual machine images.
- **[Terraform](https://www.terraform.io/) &mdash;** Infrastructure provisioning and management tool.
- **[Nomad Pack](https://github.com/hashicorp/nomad-pack) &mdash;** A tool for templated run of jobs in [**Nomad**](https://www.nomadproject.io/).

## :material-developer-board: Nodes

This project can run on a variety of hardware, provided the following approximate minimum requirements are met:

- **Processor:** dual-core, with **x86-64** or **ARM64** architecture.
- **RAM:** **1 GB**.
- **Free disk space:** **5 GB**.

### :material-lan: Networking

In the best case scenario, all nodes should be able to communicate with each other directly, but it is enough that at least one node is accessible to all others.
However, all nodes must be accessible to the controller-node via SSH.
