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

variable "resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 512,
    memory = 512
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

variable "service" {
  description = "Specifies integrations with Nomad or Consul for service discovery."
  type = object({
    name     = string
    port     = string
    tags     = list(string)
    provider = string
  })
  default = {
    name     = "lavalink"
    port     = "lavalink"
    tags     = []
    provider = "nomad"
  }
}

variable "config" {
  description = "Lavalink configuration."
  type = object({
    password = string
    source = object({
      youtube     = object({ enabled = bool })
      bandcamp    = object({ enabled = bool })
      soundcloud  = object({ enabled = bool })
      twitch      = object({ enabled = bool })
      vimeo       = object({ enabled = bool })
      http        = object({ enabled = bool })
      local       = object({ enabled = bool })
      deezer      = object({ enabled = bool })
      flowery_tts = object({ enabled = bool })

      spotify = object({
        enabled       = bool
        country_code  = string
        client_id     = string
        client_secret = string
      })

      apple_music = object({
        enabled         = bool
        media_api_token = string
        country_code    = string
      })

      yandex_music = object({
        enabled      = bool,
        access_token = string
      })
    })
  })
  default = {
    password = ""
    source = {
      youtube     = { enabled = false }
      bandcamp    = { enabled = false }
      soundcloud  = { enabled = false }
      twitch      = { enabled = false }
      vimeo       = { enabled = false }
      http        = { enabled = false }
      local       = { enabled = false }
      deezer      = { enabled = false }
      flowery_tts = { enabled = false }

      spotify = {
        enabled       = false
        country_code  = "US"
        client_id     = ""
        client_secret = ""
      }

      apple_music = {
        enabled         = false
        country_code    = "US"
        media_api_token = ""
      }

      yandex_music = {
        enabled      = false
        access_token = ""
      }
    }
  }
}

variable "artifact_source" {
  description = "Lavalink artifact source."
  type        = string
  default     = "https://github.com/lavalink-devs/Lavalink/releases/download/4.0.4/Lavalink.jar"
}
