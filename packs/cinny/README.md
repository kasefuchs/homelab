<p align="center">
  <a href="https://cinny.in/" rel="noopener">
 <img width=200px height=200px src="https://git.kasefuchs.su/kasefuchs/homelab/media/branch/main/assets/logos/cinny.svg" alt="Project logo"></a>
</p>

<h3 align="center">Cinny Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Cinny within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Cinny on a Nomad cluster. It uses the Docker driver.

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

- "config_path" (string) - Path where the Cinny configuration file will be stored.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "count" (number) - The number of application instances to deploy.
- "artifact_source" (string) - URL of compiled Cinny artifact.
- "resources" (object) - Resources to assign to the task.
- "config" (string) - Cinny configuration in JSON format.
- "home_path" (string) - Home path where the extracted Cinny artifact will be served.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Integrations with Nomad or Consul for service discovery.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
service = {
  provider     = "consul"
  name         = "cinny"
  port         = "cinny"
  host_network = "localhost"
  tags         = [
    "traefik.enable=true",
    "traefik.http.routers.cinny.rule=Host(`cinny.example.com`)",
  ]
}
```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
