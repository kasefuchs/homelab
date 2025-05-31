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
    mode = "bridge"
    ports = [
      {
        name         = "connect-proxy-gotify"
        to           = -1
        static       = 0
        host_network = "connect"
      },
      {
        name         = "service-check-gotify"
        to           = -1
        static       = 0
        host_network = "private"
      }
    ]
    dns = null
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
          restart = object({
            limit           = number
            grace           = string
            ignore_warnings = bool
          })
          command         = string
          interval        = string
          method          = string
          body            = string
          name            = string
          path            = string
          expose          = bool
          port            = string
          protocol        = string
          task            = string
          timeout         = string
          type            = string
          tls_server_name = string
          tls_skip_verify = bool
          headers         = string
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
            port = string
            proxy = object({
              expose = list(
                object({
                  path          = string
                  protocol      = string
                  local_port    = number
                  listener_port = string
                })
              )
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
      name     = "gotify"
      port     = "80"
      tags     = []
      provider = "consul"
      checks = [
        {
          address_mode    = null
          args            = null
          restart         = null
          command         = null
          interval        = "30s"
          method          = null
          body            = null
          name            = null
          path            = "/health"
          expose          = false
          port            = "service-check-gotify"
          protocol        = "http"
          task            = null
          timeout         = "5s"
          type            = "http"
          tls_server_name = null
          tls_skip_verify = false
          headers         = null
        }
      ]
      connect = {
        native = false
        sidecar = {
          task = null
          service = {
            port = "connect-proxy-gotify"
            proxy = {
              expose = [
                {
                  path          = "/health"
                  protocol      = "http"
                  local_port    = 80
                  listener_port = "service-check-gotify"
                }
              ]
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
    image      = "ghcr.io/gotify/server:latest"
    entrypoint = null
    args       = null
    volumes    = ["local/config.yml:/etc/gotify/config.yml"]
    privileged = false
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
pluginsdir: /var/gotify/data/plugins
uploadedimagesdir: /var/gotify/data/images

database:
  dialect: sqlite3
  connection: /var/gotify/data/gotify.db
      EOH
      destination   = "$${NOMAD_TASK_DIR}/config.yml"
      change_mode   = "restart"
      change_signal = null
      env           = false
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

variable "resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 48,
    memory = 96
  }
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
      source          = "gotify-data"
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
      destination   = "/var/gotify/data"
      read_only     = false
      selinux_label = null
    }
  ]
}

variable "restart" {
  description = "Configures a task behavior on failure."
  type = object({
    attempts         = number
    delay            = string
    interval         = string
    mode             = string
    render_templates = bool
  })
  default = {
    mode             = "fail"
    delay            = "15s"
    interval         = "10m"
    attempts         = 3
    render_templates = false
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

variable "count" {
  description = "Specifies the number of instances that should be running under for this group."
  type        = number
  default     = 1
}
