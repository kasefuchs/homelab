---
icon: material/map-check
title: Prerequisites
---

## :material-map-check: Prerequisites

## :material-developer-board: Cluster nodes

This project can be run on any modern system.
I recommend using workstations like [Intel NUC](https://en.wikipedia.org/wiki/Next_Unit_of_Computing) as nodes.
Also no one forbids to use VPS as nodes, for example to provide access from external internet if you don't have a white IP.

### :material-access-point-network: Network requirements

[Tailscale](https://tailscale.com) is used for communication between nodes, since all nodes must be able to communicate with each other.
In addition, nodes must be accessible to the controller node via SSH.

### :material-monitor-dashboard: Operating System Requirements

This project is only intended to work with [Debian 12](https://www.debian.org/releases/stable/releasenotes.ru.html),
but it can also work with other distributions that use Debian as a base, such as [Ubuntu Server](https://ubuntu.com/download/server).

## :material-remote-desktop: Controller node

You will need a separate workstation, such as your PC, to automatically deploy all the necessary software.

You must have the following software installed on your system:

* [:simple-ansible: Ansible](https://www.ansible.com/)
* [:simple-nomad: Nomad Pack](https://github.com/hashicorp/nomad-pack)
* [:material-alpha-t-box: Tailscale](https://tailscale.com)
