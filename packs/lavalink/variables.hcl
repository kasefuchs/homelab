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

variable "host_network" {
  description = "Designates the host network name to use when allocating the port."
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
    cpu    = 512,
    memory = 512
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
    name     = string
    port     = string
    tags     = list(string)
    provider = string
  })
  default = {
    name     = "lavalink"
    port     = "lavalink"
    tags     = []
    provider = "nomad"
  }
}

variable "config" {
  description = "Lavalink configuration."
  type        = string
  default     = <<EOH
---
lavalink:
  server:
    password: "youshallnotpass"
  EOH
}

variable "artifact_source" {
  description = "Lavalink artifact source."
  type        = string
  default     = "https://github.com/lavalink-devs/Lavalink/releases/download/4.0.5/Lavalink.jar"
}
