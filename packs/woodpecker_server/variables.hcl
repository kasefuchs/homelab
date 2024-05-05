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

variable "resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 64,
    memory = 64
  }
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default = {
    WOODPECKER_OPEN  = true
    WOODPECKER_GITEA = true
    WOODPECKER_HOST  = "https://example.com"
  }
}

variable "http_service" {
  description = "Integrations with Nomad or Consul for service discovery."
  type = object({
    name     = string
    port     = string
    tags     = list(string)
    provider = string
  })
  default = {
    name     = "woodpecker-server-http"
    port     = "woodpecker-server-http"
    tags     = []
    provider = "nomad"
  }
}

variable "grpc_service" {
  description = "Integrations with Nomad or Consul for service discovery."
  type = object({
    name     = string
    port     = string
    tags     = list(string)
    provider = string
  })
  default = {
    name     = "woodpecker-server-grpc"
    port     = "woodpecker-server-grpc"
    tags     = []
    provider = "nomad"
  }
}
