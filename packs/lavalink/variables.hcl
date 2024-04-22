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
  description = "The host network to which bind service."
  type        = string
  default     = "tailscale"
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

variable "service_tags" {
  description = "Tags to use for service."
  type        = list(string)
  default     = []
}

variable "service_name" {
  description = "Name for service."
  type        = string
  default     = "lavalink"
}

variable "resources" {
  description = "The resource to assign to the lavalink service task."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 512,
    memory = 512
  }
}

variable "artifact_source" {
  description = "Lavalink artifact source."
  type        = string
  default     = "https://github.com/lavalink-devs/Lavalink/releases/download/4.0.4/Lavalink.jar"
}

variable "env" {
  description = "Environment variables for task."
  type        = map(string)
  default     = {}
}

variable "lavalink_config_file" {
  description = "Lavalink configuration file template."
  type        = string
}

