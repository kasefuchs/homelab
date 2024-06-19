<p align="center">
  <a href="https://coder.com/" rel="noopener">
 <img width=200px height=200px src="https://codeberg.org/kasefuchs/homelab/media/branch/main/assets/logos/coder.svg" alt="Coder logo"></a>
</p>

<h3 align="center">Coder Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Coder within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Coder on a Nomad cluster. It uses the Docker driver.

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

- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.
- "environment" (map of string) - Environment variables to pass to task.
- "terraform_config" (string) - Terraform configuration in HCL format.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "region" (string) - The region where jobs will be deployed.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the application.
- "constraints" (list of object) - Additional constraints to apply to the job.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
service = {
  provider     = "consul"
  name         = "coder"
  port         = "server"
  host_network = ""
  tags         = [
    "traefik.enable=true",
    "traefik.http.routers.coder.rule=Host(`coder.example.com`)",
  ]
}

environment = {
  CODER_ACCESS_URL          = "https://coder.example.com"
  CODER_PG_CONNECTION_URL   = "postgres://coder:coder@postgres.service.consul:5432/coder?sslmode=disable"
}
```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
