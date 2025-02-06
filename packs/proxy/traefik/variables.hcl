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

variable "ui_description" {
  description = "The markdown-enabled description of the job."
  type        = string
  default     = ""
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

variable "services" {
  description = "Specifies integrations with Consul for service discovery."
  type = list(
    object({
      name = string
      port = string
      tags = list(string)
      connect = object({
        native = bool
        sidecar = object({
          config = object({
            protocol = string
          })
          resources = object({
            cpu    = number
            memory = number
          })
          upstreams = list(
            object({
              name = string
              port = number
            })
          )
        })
      })
    })
  )
  default = [
    {
      name = "traefik"
      port = "http"
      tags = []
      connect = {
        native  = true
        sidecar = null
      }
    }
  ]
}

variable "vault" {
  description = "Allows a task to specify that it requires a token from a HashiCorp Vault server."
  type = object({
    role = string
  })
  default = null
}

variable "ports" {
  description = "Nomad ports to use."
  type = list(
    object({
      name         = string
      to           = number
      static       = number
      host_network = string
    })
  )
  default = [
    {
      name         = "http"
      to           = 80
      static       = 80
      host_network = "public"
    }
  ]
}

variable "docker_config" {
  description = "Docker driver task configuration."
  type = object({
    image      = string
    entrypoint = list(string)
    args       = list(string)
    volumes    = list(string)
  })
  default = {
    image      = "traefik:latest"
    entrypoint = null
    args       = ["--configFile", "$${NOMAD_TASK_DIR}/static.yml"]
    volumes    = []
  }
}

variable "templates" {
  description = "List of templates to render."
  type = list(
    object({
      data        = string
      destination = string
      change_mode = string
    })
  )
  default = [
    {
      data        = <<EOH
---
providers:
  consulCatalog:
    serviceName: traefik
    connectAware: true
    connectByDefault: true
    exposedByDefault: false

entryPoints:
  http:
    address: :80
      EOH
      destination = "$${NOMAD_TASK_DIR}/static.yml"
      change_mode = "restart"
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
    cpu    = 128,
    memory = 128
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
  default = []
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
  default = []
}
