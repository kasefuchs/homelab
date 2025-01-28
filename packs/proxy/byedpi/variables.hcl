variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
}

variable "ui_description" {
  description = "The markdown-enabled description of the job."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where jobs will be deployed."
  type        = string
  default     = "global"
}

variable "namespace" {
  description = "The namespace in which to execute the job."
  type        = string
  default     = "default"
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

variable "port" {
  description = "Nomad port to use."
  type = object({
    name         = string
    to           = number
    static       = number
    host_network = string
  })
  default = null
}

variable "service" {
  description = "Specifies integrations with Consul for service discovery."
  type = object({
    name = string
    port = string
    tags = list(string)
    connect = object({
      native = bool
      sidecar = object({
        resources = object({
          cpu    = number
          memory = number
        })
        upstreams = list(
          object({
            name = string
            port = number
          })
        )
      })
    })
  })
  default = {
    name = "byedpi"
    port = "1080"
    tags = []
    connect = {
      native = false
      sidecar = {
        upstreams = []
        resources = null
      }
    }
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "tazihad/byedpi:latest"
}

variable "arguments" {
  description = "List of arguments to pass to application."
  type        = list(string)
  default     = ["--ip=0.0.0.0", "--port=1080"]
}

variable "environment" {
  description = "Environment variables to pass to task."
  type        = map(string)
  default     = {}
}

variable "artifacts" {
  description = "Instructs Nomad to fetch and unpack a remote resource."
  type = list(
    object({
      source      = string
      destination = string
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
