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
    cpu    = 16,
    memory = 64
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

variable "type" {
  description = "Specifies the Nomad scheduler to use."
  type        = string
  default     = "system"
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
  nomad:
    address: "unix://{{ env "NOMAD_SECRETS_DIR" }}/api.sock"
    secretID: "{{ env "NOMAD_TOKEN" }}"
    watchByDefault: true
  EOH
}

variable "volumes" {
  description = "A list of host_path:container_path strings to bind host paths to container paths."
  type        = list(string)
  default     = []
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
