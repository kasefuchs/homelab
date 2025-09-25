variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "meta" {
  type = map(string)
}

variable "capabilities" {
  type = object({
    task_drivers = optional(
      object({
        enabled  = optional(list(string))
        disabled = optional(list(string))
      })
    )
  })
}
