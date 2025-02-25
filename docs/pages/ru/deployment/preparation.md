---
icon: material/list-box
title: Подготовка
---

# :material-list-box: Подготовка

## :material-ansible: Установка Ansible

```shell
# Переход в рабочую директорию Ansible.
cd ansible/

# Создание виртуального окружения Python и его активация. 
python -m venv .venv/
source .venv/bin/activate.sh

# Установка Ansible и его зависимостей.
pip install -r requirements.txt
```

## :material-test-tube: Создание тестовых узлов

!!! warning "Внимание"
    Тестовые узлы используются исключительно для целей разработки и тестирования проекта.

    Вы можете пропустить этот этап если хотите развернуть проект сразу на физических или облачных серверах.

### :material-disc: Сборка образа

```shell
# Активация виртуального окружения Python для корректной работы Ansible.
source ../../../ansible/.venv/bin/activate

# Загрузка базового образа.
curl --output /tmp/centos-stream-9.box "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-latest.x86_64.vagrant-virtualbox.box"

# Импорт базового образа в Vagrant.
vagrant box add --provider=virtualbox --name=centos/stream9 /tmp/centos-stream-9.box

# Переход в рабочую директорию Packer.
cd packer/infrastructure/vagrant/

# Установка зависимостей.
packer init .

# Сборка образа.
packer build .

# Импорт собранного образа в Vagrant.
vagrant box add --provider=virtualbox --name=homelab/centos output-box/package.box 
```

### :material-rocket-launch: Запуск тестовых узлов

```shell
# Переход в рабочую директорию Vagrant.
cd vagrant/

# Запуск узлов.
vagrant up
```
