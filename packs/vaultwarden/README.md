<p align="center">
  <a href="https://github.com/dani-garcia/vaultwarden" rel="noopener">
  <img width=192px src="https://raw.githubusercontent.com/dani-garcia/vaultwarden/main/resources/vaultwarden-logo-white.svg" alt="Vaultwarden logo"></a>
</p>

<h3 align="center">Vaultwarden Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Vaultwarden within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Vaultwarden on a Nomad cluster. It uses the Docker driver.

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

- "region" (string) - The region where jobs will be deployed.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the application.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.
- "environment" (map of string) - Environment variables to pass to task.
- "volume" (object) - Volume containing vaultwarden data.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
service = {
  provider     = "consul"
  name         = "vaultwarden"
  port         = "vaultwarden"
  host_network = "localhost"
  tags         = [
    "traefik.enable=true",
    "traefik.http.routers.vaultwarden.rule=Host(`vaultwarden.example.com`)",
  ]
}

environment = {
  DOMAIN       = "https://vaultwarden.example.com"
  DATABASE_URL = "postgresql://vaultwarden:vaultwarden@postgres.service.consul:5432/vaultwarden?sslmode=disable"
}
```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
