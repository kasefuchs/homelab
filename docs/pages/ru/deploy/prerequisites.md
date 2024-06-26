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
- [:material-alpha-t-box: Tailscale](https://tailscale.com)

## :material-developer-board: Узлы кластера

Я рекомендую использовать в качестве узлов рабочие станции наподобие [Intel NUC](https://en.wikipedia.org/wiki/Next_Unit_of_Computing).
Также никто не запрещает использовать VPS в качестве узлов, например для обеспечения доступа из внешнего интернета, если у вас нет белого IP.

### :material-monitor-dashboard: Требования к операционной системе

Данный проект предназначен только для работы с [Debian 12](https://www.debian.org/releases/stable/releasenotes.ru.html),
но он также может работать с другими дистрибутивами, использующими Debian в качестве основы, например [Ubuntu Server](https://ubuntu.com/download/server).

### :material-access-point-network: Требования к сети

Для связи между узлами используется [Tailscale](https://tailscale.com), ибо все участники сети должны иметь возможность взаимодействовать друг с другом,
поэтому узлы должны иметь доступ к TUN/TAP интерфейсу. Кроме того, узлы должны быть доступны узлу-контроллеру посредством SSH.
