---
icon: material/map-check
title: Необходимое
---

# :material-map-check: Необходимое

В данном разделе описывается всё, что необходимо вам иметь, для развёртывания своего кластера.

---

## :material-remote-desktop: Узел-контроллер

Для автоматического развертывания всего необходимого программного обеспечения вам понадобится отдельная рабочая станция, например ваш ПК.

В вашей системе должно быть установлено следующее программное обеспечение:

- [:simple-ansible: Ansible](https://www.ansible.com/)
- [:simple-nomad: Nomad Pack](https://github.com/hashicorp/nomad-pack)

## :material-developer-board: Узлы кластера

Я рекомендую использовать в качестве узлов рабочие станции наподобие [Intel NUC](https://en.wikipedia.org/wiki/Next_Unit_of_Computing).
Также никто не запрещает использовать VPS в качестве узлов, например для обеспечения доступа из внешнего интернета, если у вас нет белого IP.

### :material-monitor-dashboard: Требования к операционной системе

Данный проект предназначен только для работы с [Debian 12](https://www.debian.org/releases/stable/releasenotes.ru.html),
но он также может работать с другими дистрибутивами, использующими Debian в качестве основы, например [Ubuntu Server](https://ubuntu.com/download/server).
