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

variable "service" {
  description = "Integrations with Nomad or Consul for service discovery."
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

variable "resources" {
  description = "Resources to assign to the task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 64,
    memory = 64
  }
}

variable "artifact_source" {
  description = "URL of compiled Cinny artifact."
  type        = string
  default     = "https://github.com/cinnyapp/cinny/releases/download/v3.2.0/cinny-v3.2.0.tar.gz"
}

variable "config" {
  description = "Cinny configuration JSON."
  type        = string
  default     = <<EOH
{
  "defaultHomeserver": 0,
  "homeserverList": ["matrix.org"],
  "allowCustomHomeservers": false
}
  EOH
}

variable "home_path" {
  description = "Home path where the extracted Cinny artifact will be served."
  type        = string
  default     = "local/cinny/dist"
}

variable "config_path" {
  description = "Path where the Cinny configuration file will be stored."
  type        = string
  default     = "local/cinny/dist/config.json"
}
