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
    memory = 128
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
  default     = "chrislusf/seaweedfs-csi-driver:latest"
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default     = {}
}

variable "options" {
  description = "Command line options, each line in optionName=optionValue format."
  type        = string
  default     = ""
}

variable "csi_plugin" {
  description = ""
  type = object({
    id   = string
    type = string
  })
  default = {
    id   = "seaweedfs"
    type = "monolith"
  }
}
