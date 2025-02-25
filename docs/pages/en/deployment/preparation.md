---
icon: material/list-box
title: Preparation
---

# :material-list-box: Preparation

## :material-ansible: Installing Ansible

```shell
# Go to the Ansible working directory.
cd ansible/

# Creating a virtual Python environment and activating it.
python -m venv .venv/
source .venv/bin/activate.sh

# Installing Ansible and its dependencies.
pip install -r requirements.txt
```

## :material-test-tube: Creating test nodes

!!! warning "Warning"
    Test nodes are used solely for the purpose of developing and testing the project.

    You can skip this step if you want to deploy the project directly on physical or cloud servers.

### :material-disc: Building image

```shell
# Activating the Python virtual environment for Ansible to work correctly.
source ../../../ansible/.venv/bin/activate

# Downloading the base image.
curl --output /tmp/centos-stream-9.box "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-latest.x86_64.vagrant-virtualbox.box"

# Importing a base image into Vagrant.
vagrant box add --provider=virtualbox --name=centos/stream9 /tmp/centos-stream-9.box

# Go to the Packer working directory.
cd packer/infrastructure/vagrant/

# Installing dependencies.
packer init .

# Building the image.
packer build .

# Importing the built image into Vagrant.
vagrant box add --provider=virtualbox --name=homelab/centos output-box/package.box 
```

### :material-rocket-launch: Running test nodes

```shell
# Go to the Vagrant working directory.
cd vagrant/

# Running nodes.
vagrant up
```
