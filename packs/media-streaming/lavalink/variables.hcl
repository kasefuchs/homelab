variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
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

variable "port" {
  description = "Nomad port to use."
  type = object({
    name         = string
    to           = number
    static       = number
    host_network = string
  })
  default = null
}

variable "service" {
  description = "Specifies integrations with Consul for service discovery."
  type = object({
    name    = string
    port    = string
    tags    = list(string)
    connect = bool
    proxy_upstreams = list(
      object({
        name = string
        port = number
      })
    )
    sidecar_resources = object({
      cpu    = number
      memory = number
    })
  })
  default = {
    name              = "lavalink"
    port              = "2333"
    tags              = []
    connect           = true
    proxy_upstreams   = []
    sidecar_resources = null
  }
}

variable "vault" {
  description = "Allows a task to specify that it requires a token from a HashiCorp Vault server."
  type = object({
    role = string
  })
  default = {
    role = ""
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "ghcr.io/lavalink-devs/lavalink:latest"
}

variable "config" {
  description = "Lavalink configuration in YAML format."
  type        = string
  default     = <<EOH
---
server:
  port: 2333
  address: 0.0.0.0
  EOH
}

variable "resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 512,
    memory = 512
  }
}
