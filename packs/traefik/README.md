<p align="center">
  <a href="https://grafana.com/oss/traefik/" rel="noopener">
 <img width=200px height=200px src="https://git.kasefuchs.su/kasefuchs/homelab/media/branch/main/assets/logos/traefik.svg" alt="Project logo"></a>
</p>

<h3 align="center">Traefik Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Traefik within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Traefik on a Nomad cluster. It uses the Docker driver.

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

- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "region" (string) - The region where jobs will be deployed.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "resources" (object) - The resource to assign to the application.
- "config" (string) - Traefik configuration in YAML format.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
config = <<EOH
---
api:
  dashboard: true
  disableDashboardAd: true

entryPoints:
  http:
    address: ":80"
    asDefault: true

providers:
  consulCatalog:
    endpoint:
      address: http://consul.service.consul:8500

  nomad:
    endpoint:
      address: http://nomad.service.consul:4646
EOH
```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
