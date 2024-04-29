---
icon: material/map-check
title: Необходимое
---

# :material-map-check: Необходимое

## :material-developer-board: Узлы кластера

Этот проект можно запустить на любой современной системе.
Я рекомендую использовать в качестве узлов рабочие станции наподобие [Intel NUC](https://en.wikipedia.org/wiki/Next_Unit_of_Computing).
Также никто не запрещает использовать VPS в качестве узлов, например для обеспечения доступа из внешнего интернета, если у вас нет белого IP.

### :material-access-point-network: Требования к сети

Для связи между узлами используется [Tailscale](https://tailscale.com), поскольку все узлы должны иметь возможность взаимодействовать друг с другом.
Кроме того, узлы должны быть доступны узлу-контроллеру посредством SSH.

### :material-monitor-dashboard: Требования к операционной системе

Данный проект предназначен только для работы с [Debian 12](https://www.debian.org/releases/stable/releasenotes.ru.html),
но он также может работать с другими дистрибутивами, использующими Debian в качестве основы, например [Ubuntu Server](https://ubuntu.com/download/server).

## :material-remote-desktop: Узел-контроллер

Для автоматического развертывания всего необходимого программного обеспечения вам понадобится отдельная рабочая станция, например ваш ПК.

В вашей системе должно быть установлено следующее программное обеспечение:

* [:simple-ansible: Ansible](https://www.ansible.com/)
* [:simple-nomad: Nomad Pack](https://github.com/hashicorp/nomad-pack)
* [:material-alpha-t-box: Tailscale](https://tailscale.com)
