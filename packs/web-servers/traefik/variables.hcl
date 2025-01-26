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

variable "service" {
  description = "Specifies integrations with Consul for service discovery."
  type = object({
    name    = string
    port    = string
    tags    = list(string)
    connect = bool
  })
  default = {
    name    = "traefik"
    port    = "http"
    tags    = []
    connect = true
  }
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

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "traefik:latest"
}

variable "arguments" {
  description = "List of arguments to pass to application."
  type        = list(string)
  default     = ["--configFile", "$${NOMAD_TASK_DIR}/static.yml"]
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
