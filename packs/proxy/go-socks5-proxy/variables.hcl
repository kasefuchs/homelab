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
    cpu    = 32,
    memory = 32
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

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "ghcr.io/kasefuchs/go-socks5-proxy:latest"
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
    name         = "go-socks5-proxy"
    port         = "server"
    tags         = []
    provider     = "nomad"
    host_network = ""
  }
}
