<p align="center">
  <a href="https://github.com/t2bot/matrix-media-repo/" rel="noopener">
  <img width=192px src="https://upload.wikimedia.org/wikipedia/commons/b/b7/Matrix_icon_%28white%29.svg" alt="Matrix Media Repo logo"></a>
</p>

<h3 align="center">Matrix Media Repo Nomad Pack</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Nomad Pack used to automatically deploy Matrix Media Repo within a Nomad cluster.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Deployment](#deployment)
- [Acknowledgments](#acknowledgement)

## 🧐 About <a name = "about"></a>

This Pack contains everything needed to deploy Matrix Media Repo on a Nomad cluster. It uses the Docker driver.

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

- "count" (number) - The number of application instances to deploy.
- "config" (string) - Matrix media repo configuration in YAML format.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the application.
- "docker_image" (string) - Docker image of application to deploy.
- "region" (string) - The region where jobs will be deployed.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.

### Install

To install this Nomad Pack to a configured Nomad Cluster:

1. Create an HCL file containing the values you want to override. For example:

```hcl
service = {
  name         = "matrix-media-repo"
  port         = "server"
  provider     = "consul"
  host_network = "localhost"
  tags         = [
    "traefik.enable=true",
    "traefik.http.routers.matrix-media-repo.priority=20",
    "traefik.http.routers.matrix-media-repo.rule=Host(`dendrite.example.com`) && PathPrefix(`/_matrix/media`)"
  ]
}

config = <<EOH
---
repo:
  bindAddress: '0.0.0.0'
  port: {{ env "REPO_BIND_PORT" }}

database:
  postgres: "postgres://matrix-media-repo:matrix-media-repo@postgres.service.consul:5432/matrix-media-repo?sslmode=disable"

homeservers:
  - name: dendrite.example.com
    csApi: "https://dendrite.example.com/"
    adminApiKind: "dendrite"

datastores:
  - type: s3
    id: garage
    forKinds:
      - thumbnails
      - remote_media
      - local_media
      - archives
    opts:
      tempPath: {{ env "NOMAD_ALLOC_DIR" }}/tmp
      endpoint: api.garage.service.consul:3900
      accessKeyId: GKd4ffb7839e02a94b
      accessSecret: d7c56c6a7c153e44ba236d577f61a8c547fdd70a7b3dfd4f737fad9811e8d690
      ssl: false
      bucketName: matrix-media-repo
      region: us-east-1
EOH
```

2. Run Nomad Pack:

```shell
$ nomad-pack run --var-file=override.hcl .
```

## 🎉 Acknowledgments <a name = "acknowledgments"></a>

- [kylelobo/The-Documentation-Compendium](https://github.com/kylelobo/The-Documentation-Compendium)
