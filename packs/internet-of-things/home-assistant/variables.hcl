variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where jobs will be deployed."
  type        = string
  default     = ""
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
    cpu    = 256,
    memory = 1024
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

variable "service" {
  description = "Specifies integrations with Nomad or Consul for service discovery."
  type = object({
    name         = string
    port         = string
    tags         = list(string)
    provider     = string
    host_network = string
  })
  default = {
    name         = "home-assistant"
    port         = "server"
    tags         = []
    provider     = "nomad"
    host_network = ""
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "homeassistant/home-assistant:latest"
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

variable "volume" {
  description = "Volume containing home assistant config."
  type = object({
    name            = string
    type            = string
    source          = string
    read_only       = bool
    access_mode     = string
    attachment_mode = string
  })
  default = {
    type            = "host"
    name            = "config"
    source          = "home-assistant"
    read_only       = false
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
}
