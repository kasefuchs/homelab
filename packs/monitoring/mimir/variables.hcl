variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
}

variable "job_type" {
  description = "Specifies the Nomad scheduler to use."
  type        = string
  default     = "service"
}

variable "ui" {
  description = "Options to modify the presentation of the Job index page in the Web UI."
  type = object({
    description = string
    links = list(
      object({
        label = string
        url   = string
      })
    )
  })
  default = null
}

variable "region" {
  description = "The region where jobs will be deployed."
  type        = string
  default     = "global"
}

variable "namespace" {
  description = "The namespace in which to execute the job."
  type        = string
  default     = "default"
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["*"]
}

variable "constraints" {
  description = "Additional constraints to apply to the job."
  type = list(
    object({
      attribute = string
      operator  = string
      value     = string
    })
  )
  default = []
}

variable "network" {
  description = "Networking requirements."
  type = object({
    mode = string
    ports = list(
      object({
        name         = string
        to           = number
        static       = number
        host_network = string
      })
    )
    dns = object({
      servers  = list(string)
      searches = list(string)
      options  = list(string)
    })
  })
  default = {
    mode  = "bridge"
    ports = []
    dns   = null
  }
}

variable "services" {
  description = "Specifies integrations for service discovery."
  type = list(
    object({
      name     = string
      port     = string
      tags     = list(string)
      provider = string
      checks = list(
        object({
          address_mode = string
          args         = list(string)
          check_restart = object({
            limit           = number
            grace           = string
            ignore_warnings = bool
          })
          command  = string
          interval = string
          method   = string
          body     = string
          name     = string
          path     = string
          expose   = bool
          port     = string
          protocol = string
          task     = string
          timeout  = string
          type     = string
        })
      )
      connect = object({
        native = bool
        sidecar = object({
          task = object({
            resources = object({
              cpu    = number
              memory = number
            })
          })
          service = object({
            proxy = object({
              upstreams = list(
                object({
                  name = string
                  port = number
                })
              )
            })
          })
        })
      })
    })
  )
  default = [
    {
      name     = "mimir"
      port     = "9009"
      tags     = []
      provider = "consul"
      checks   = []
      connect = {
        native = false
        sidecar = {
          task = null
          service = {
            proxy = {
              upstreams = []
            }
          }
        }
      }
    }
  ]
}

variable "vault" {
  description = "Allows a task to specify that it requires a token from a HashiCorp Vault server."
  type = object({
    env           = bool
    role          = string
    change_mode   = string
    change_signal = string
  })
  default = null
}

variable "consul" {
  description = "Specifies Consul configuration options specific to a task."
  type        = object({})
  default     = null
}

variable "docker_config" {
  description = "Docker driver task configuration."
  type = object({
    image      = string
    entrypoint = list(string)
    args       = list(string)
    volumes    = list(string)
    privileged = bool
  })
  default = {
    image      = "grafana/mimir:latest"
    entrypoint = null
    args       = ["--config.file=$${NOMAD_TASK_DIR}/mimir.yml"]
    volumes    = []
    privileged = false
  }
}

variable "resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 128,
    memory = 256
  }
}

variable "templates" {
  description = "List of templates to render."
  type = list(
    object({
      data          = string
      destination   = string
      change_mode   = string
      change_signal = string
      env           = bool
    })
  )
  default = [
    {
      data          = <<EOH
---
blocks_storage:
  backend: filesystem
  bucket_store:
    sync_dir: /mimir/tsdb-sync
  filesystem:
    dir: /mimir/data/tsdb
  tsdb:
    dir: /mimir/tsdb

compactor:
  data_dir: /mimir/compactor
  sharding_ring:
    kvstore:
      store: memberlist

distributor:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: memberlist

ingester:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: memberlist
    replication_factor: 1

ruler_storage:
  backend: filesystem
  filesystem:
    dir: /mimir/rules

server:
  http_listen_port: 9009
  log_level: error

store_gateway:
  sharding_ring:
    replication_factor: 1
      EOH
      destination   = "$${NOMAD_TASK_DIR}/mimir.yml"
      change_mode   = "restart"
      change_signal = null
      env           = false
    }
  ]
}

variable "volumes" {
  description = "Volumes to require."
  type = list(
    object({
      name            = string
      type            = string
      source          = string
      read_only       = bool
      access_mode     = string
      attachment_mode = string
    })
  )
  default = [
    {
      type            = "host"
      name            = "data"
      source          = "mimir-data"
      read_only       = false
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  ]
}

variable "volume_mounts" {
  description = "Volumes to mount."
  type = list(
    object({
      volume        = string
      destination   = string
      read_only     = bool
      selinux_label = string
    })
  )
  default = [
    {
      volume        = "data"
      destination   = "/mimir"
      read_only     = false
      selinux_label = null
    }
  ]
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default     = {}
}

variable "artifacts" {
  description = "Instructs Nomad to fetch and unpack a remote resource."
  type = list(
    object({
      source      = string
      destination = string
      mode        = string
    })
  )
  default = []
}

variable "restart" {
  description = "Configures a task behavior on failure."
  type = object({
    attempts = number
    delay    = string
    interval = string
    mode     = string
  })
  default = {
    mode     = "fail"
    delay    = "15s"
    interval = "10m"
    attempts = 3
  }
}

variable "identities" {
  description = "Allows a task access to its Workload Identity via an environment variable or file."
  type = list(
    object({
      name          = string
      env           = bool
      file          = bool
      audience      = list(string)
      change_mode   = string
      change_signal = string
    })
  )
  default = []
}
