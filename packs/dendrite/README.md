<p align="center">
  <a href="https://matrix-org.github.io/dendrite/" rel="noopener">
  <img width=192px src="https://upload.wikimedia.org/wikipedia/commons/b/b7/Matrix_icon_%28white%29.svg" alt="Dendrite logo"></a>
</p>

<h3 align="center">Dendrite Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Dendrite within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Dendrite on a Nomad cluster. It uses the Docker driver.

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
- 
- "region" (string) - The region where jobs will be deployed.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the application.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.
- "matrix_key" (string) - Matrix private key in PEM format.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "docker_image" (string) - Docker image of application to deploy.
- "count" (number) - The number of application instances to deploy.
- "config" (string) - Dendrite configuration in YAML format.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
service = {
  name         = "dendrite"
  port         = "server"
  tags         = ["traefik.enable=true", "traefik.http.routers.dendrite.rule=Host(`dendrite.example.com`)"]
  provider     = "consul"
  host_network = "localhost"
}

matrix_key = <<EOH
-----BEGIN MATRIX PRIVATE KEY-----
Key-ID: ed25519:9843799b

5dce4c1b3e79cf6efc5cfc9e09679bf7
-----END MATRIX PRIVATE KEY-----
EOH

config = <<EOH
---
version: 2

global:
  server_name: dendrite.example.com

  private_key: {{ env "MATRIX_PRIVATE_KEY" }}

  database:
    connection_string: postgresql://dendrite:dendrite@postgres.service.consul/dendrite?sslmode=disable

  well_known_server_name: "dendrite.example.com:443"
  well_known_client_name: "https://dendrite.example.com"

  jetstream:
    topic_prefix: Dendrite
    addresses:
{{ range service "client.nats" }}
      - {{ .Address }}:{{ .Port }}
{{ end }}

media_api:
  base_path: {{ env "NOMAD_ALLOC_DIR" }}/tmp
EOH
```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
