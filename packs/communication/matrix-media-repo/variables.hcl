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
    cpu    = 256,
    memory = 256
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
    name         = "matrix-media-repo"
    port         = "server"
    tags         = []
    provider     = "consul"
    host_network = ""
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "turt2live/matrix-media-repo:v1.3.7"
}

variable "count" {
  description = "The number of application instances to deploy."
  type        = number
  default     = 1
}

variable "config" {
  description = "Matrix media repo configuration in YAML format."
  type        = string
}
