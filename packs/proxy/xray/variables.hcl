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
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 64,
    memory = 96
  }
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
  description = "Integrations with Nomad or Consul for service discovery."
  type = list(
    object({
      name         = string
      port         = string
      tags         = list(string)
      provider     = string
      host_network = string
    })
  )
  default = []
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "teddysun/xray:latest"
}

variable "config" {
  description = "Xray configuration in JSON format."
  type        = string
}

variable "artifacts" {
  description = ""
  type = list(
    object({
      source      = string
      destination = string
    })
  )
  default = []
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default     = {}
}
