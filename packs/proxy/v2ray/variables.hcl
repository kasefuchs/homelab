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

variable "ports" {
  description = "Nomad ports to use."
  type = list(
    object({
      name         = string
      to           = number
      static       = number
      host_network = string
  }))
  default = []
}

variable "services" {
  description = "Specifies integrations with Consul for service discovery."
  type = list(
    object({
      name    = string
      port    = string
      tags    = list(string)
      connect = bool
      proxy_upstreams = list(
        object({
          name = string
          port = number
        })
      )
      sidecar_resources = object({
        cpu    = number
        memory = number
      })
    })
  )
  default = [
    {
      name              = "v2ray-http"
      port              = "1080"
      tags              = []
      connect           = true
      proxy_upstreams   = []
      sidecar_resources = null
    }
  ]
}

variable "vault" {
  description = "Allows a task to specify that it requires a token from a HashiCorp Vault server."
  type = object({
    role = string
  })
  default = {
    role = ""
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "ghcr.io/v2fly/v2ray:v5.24"
}

variable "arguments" {
  description = "List of arguments to pass to application."
  type        = list(string)
  default     = ["run", "-config", "$${NOMAD_TASK_DIR}/config.json", "-format", "jsonv5"]
}

variable "templates" {
  description = "List of templates to render."
  type = list(
    object({
      data        = string
      destination = string
      change_mode = string
    })
  )
  default = [
    {
      data        = <<EOH
{
  "inbounds": [
    {
      "protocol": "http",
      "listen": "0.0.0.0",
      "port": 1080
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
      EOH
      destination = "$${NOMAD_TASK_DIR}/config.json"
      change_mode = "restart"
    }
  ]
}

variable "resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 128,
    memory = 128
  }
}
