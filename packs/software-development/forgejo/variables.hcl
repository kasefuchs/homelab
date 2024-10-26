variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where jobs will be deployed."
  type        = string
  default     = "global"
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["*"]
}

variable "resources" {
  description = "The resource to assign to the application."
  type        = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 128,
    memory = 512
  }
}

variable "constraints" {
  description = "Additional constraints to apply to the job."
  type        = list(
    object({
      attribute = string
      operator  = string
      value     = string
    })
  )
  default = []
}

variable "service" {
  description = "Specifies integrations with Nomad or Consul for service discovery."
  type        = object({
    name         = string
    port         = string
    tags         = list(string)
    provider     = string
    host_network = string
  })
  default = {
    name         = "forgejo"
    port         = "server"
    tags         = []
    provider     = "nomad"
    host_network = ""
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "codeberg.org/forgejo/forgejo:9"
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default     = {}
}

variable "dotenv" {
  description = "Environment variables in dotenv format."
  type        = string
  default     = ""
}

variable "data_volume" {
  description = "Volume containing data."
  type        = object({
    name      = string
    type      = string
    source    = string
    read_only = bool
  })
  default = {
    type      = "host"
    name      = "data"
    source    = "forgejo-data"
    read_only = false
  }
}

variable "custom_volume" {
  description = "Volume containing custom templates and other options."
  type        = object({
    name      = string
    type      = string
    source    = string
    read_only = bool
  })
  default = {
    type      = "host"
    name      = "custom"
    source    = "forgejo-custom"
    read_only = false
  }
}

variable "repository_volume" {
  description = "Volume containing repositories."
  type        = object({
    name      = string
    type      = string
    source    = string
    read_only = bool
  })
  default = {
    type      = "host"
    name      = "repository"
    source    = "forgejo-repository"
    read_only = false
  }
}
