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

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "crazymax/diun:latest"
}

variable "config" {
  description = "Diun config in YAML format."
  type        = string
  default     = <<EOH
---
watch:
  workers: 10
  schedule: "0 */6 * * *"

providers:
  docker:
    watchByDefault: true
  EOH
}
