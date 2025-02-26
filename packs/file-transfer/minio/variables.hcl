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
      name     = "minio-api"
      port     = "9000"
      tags     = []
      provider = "consul"
      connect = {
        native = false
        sidecar = {
          config = {
            protocol = "http"
          }
          upstreams = []
          resources = null
        }
      }
    },
    {
      name     = "minio-console"
      port     = "9001"
      tags     = []
      provider = "consul"
      connect = {
        native = false
        sidecar = {
          config = {
            protocol = "http"
          }
          upstreams = []
          resources = null
        }
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
    image      = "quay.io/minio/minio:latest"
    entrypoint = null
    args = [
      "server", "/data",
      "--console-address", ":9001",
    ]
    volumes    = []
    privileged = false
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
  default = []
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
    cpu    = 256,
    memory = 1024
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
      source          = "minio-data"
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
      destination   = "/data"
      read_only     = false
      selinux_label = null
    }
  ]
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
