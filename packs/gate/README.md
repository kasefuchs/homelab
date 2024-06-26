<p align="center">
  <a href="https://gate.minekube.com/" rel="noopener">
  <img width=192px src="https://gate.minekube.com/minekube-logo.png" alt="Gate Proxy logo"></a>
</p>

<h3 align="center">Gate Proxy Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Gate Proxy within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Gate Proxy on a Nomad cluster. It uses the Docker driver.

## 🏁 Getting Started <a name = "getting_started"></a>

See [deployment](#deployment) for notes on how to deploy this Nomad Pack to a Nomad cluster.

### Prerequisites

What things you need to deploy this Nomad Pack:

- Working [Nomad](https://www.nomadproject.io/) cluster.
- [Nomad Pack](https://github.com/hashicorp/nomad-pack) version `0.1.1` or higher.

## 🚀 Deployment <a name = "deployment"></a>

How to deploy this Nomad Pack? Pretty simple!

### Variables

All variables that you can override in this Nomad Pack.

- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the application.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.
- "count" (number) - The number of application instances to deploy.
- "config" (string) - Gate configuration in YAML format.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "region" (string) - The region where jobs will be deployed.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
service = {
  provider     = "consul"
  name         = "gate"
  port         = "server"
  host_network = ""
  tags         = [
    "traefik.enable=true",
    "traefik.tcp.routers.gate.rule=HostSNI(`*`)",
  ]
}

connect_token = "minekube_connect_token"

config = <<EOH
---
config:
  bind: {{ env "GATE_CONFIG_BIND" }}

  lite:
    enabled: true
    routes:
      - host: hypixel.example.com
        backend: mc.hypixel.net:25565

connect:
  enabled: true
  name: gate-nomad
  tokenFilePath: {{ env "GATE_CONNECT_TOKEN_FILE" }}
EOH

```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
