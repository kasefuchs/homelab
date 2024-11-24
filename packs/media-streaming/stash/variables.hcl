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
    cpu    = 192,
    memory = 384
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
    name         = string
    port         = string
    tags         = list(string)
    provider     = string
    host_network = string
  })
  default = {
    name         = "stash"
    port         = "server"
    tags         = []
    provider     = "nomad"
    host_network = ""
  }
}

variable "docker_image" {
  description = "Docker image of application to deploy."
  type        = string
  default     = "stashapp/stash:latest"
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

variable "blobs_volume" {
  description = "Volume containing stash blobs."
  type = object({
    name            = string
    type            = string
    source          = string
    read_only       = bool
    access_mode     = string
    attachment_mode = string
  })
  default = {
    type            = "host"
    name            = "blobs"
    source          = "stash-blobs"
    read_only       = false
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
}

variable "media_volume" {
  description = "Volume containing stash media."
  type = object({
    name            = string
    type            = string
    source          = string
    read_only       = bool
    access_mode     = string
    attachment_mode = string
  })
  default = {
    type            = "host"
    name            = "media"
    source          = "stash-media"
    read_only       = false
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
}

variable "database_volume" {
  description = "Volume containing stash database data."
  type = object({
    name            = string
    type            = string
    source          = string
    read_only       = bool
    access_mode     = string
    attachment_mode = string
  })
  default = {
    type            = "host"
    name            = "database"
    source          = "stash-database"
    read_only       = false
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
}

variable "generated_volume" {
  description = "Volume containing stash generated data."
  type = object({
    name            = string
    type            = string
    source          = string
    read_only       = bool
    access_mode     = string
    attachment_mode = string
  })
  default = {
    type            = "host"
    name            = "generated"
    source          = "stash-generated"
    read_only       = false
    access_mode     = "single-node-writer"
    attachment_mode = "file-system"
  }
}

variable "config" {
  description = "Stash configuration in YAML format."
  type        = string
  default     = <<EOH
---
# Cache.
cache: {{ env "STASH_CACHE_DIR" }}

# Blobs
blobs_path: {{ env "STASH_BLOBS_DIR" }}
blobs_storage: FILESYSTEM

# Database.
database: {{ env "STASH_DATABASE_DIR" }}/stash-go.sqlite

# Generated.
generated: {{ env "STASH_GENERATED_DIR" }}

# Media.
stash:
  - path: {{ env "STASH_MEDIA_DIR" }}
    excludevideo: false
    excludeimage: false
  EOH
}
