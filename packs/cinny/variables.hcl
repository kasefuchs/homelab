variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["*"]
}

variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
}

variable "host_network" {
  description = "The host network to which bind services."
  type        = string
  default     = ""
}

variable "count" {
  description = "The number of application instances to deploy."
  type        = number
  default     = 1
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

variable "artifact" {
  description = "Specifies url of compiled Cinny artifact."
  type        = string
  default     = "https://github.com/cinnyapp/cinny/releases/download/v3.2.0/cinny-v3.2.0.tar.gz"
}

variable "service" {
  description = "Specifies integrations with Nomad or Consul for service discovery."
  type = object({
    name     = string
    port     = string
    tags     = list(string)
    provider = string
  })
  default = {
    name     = "cinny"
    port     = "cinny"
    tags     = []
    provider = "nomad"
  }
}

variable "home_path" {
  description = "Specifies the home path where the extracted Cinny artifact will be served."
  type        = string
  default     = "local/dist"
}

variable "config_path" {
  description = "Specifies the path where the Cinny configuration file will be stored."
  type        = string
  default     = "local/dist/config.json"
}

variable "resources" {
  description = "The resource to assign to the task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 64,
    memory = 64
  }
}

variable "config" {
  description = "Specifies cinny configuration to use."
  type = object({
    homeservers              = list(string)
    default_homeserver_index = number
    allow_custom_homeservers = bool
  })
  default = {
    homeservers              = ["matrix.org"]
    default_homeserver_index = 0
    allow_custom_homeservers = true
  }
}
