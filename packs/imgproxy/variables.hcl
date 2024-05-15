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
    cpu    = 256,
    memory = 192
  }
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default     = {}
}

variable "count" {
  description = "The number of application instances to deploy."
  type        = number
  default     = 1
}

variable "service" {
  description = "Integrations with Nomad or Consul for service discovery."
  type = object({
    name           = string
    port           = string
    tags           = list(string)
    provider       = string
    check_interval = string
    check_timeout  = string
  })
  default = {
    name           = "imgproxy"
    port           = "imgproxy"
    tags           = []
    provider       = "nomad"
    check_interval = "15s"
    check_timeout  = "3s"
  }
}
