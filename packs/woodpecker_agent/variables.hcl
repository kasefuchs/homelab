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

variable "agent_resources" {
  description = "The resource to assign to the agent."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 64,
    memory = 64
  }
}

variable "engine_resources" {
  description = "The resource to assign to the docker engine."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 384,
    memory = 384
  }
}

variable "environment" {
  description = "Environment variables to pass to agent."
  type        = map(string)
  default     = {}
}
