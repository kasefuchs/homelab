variable "dynamic_host" {
  type = list(
    object({
      name      = string
      plugin    = string
      namespace = optional(string, "default")
      node = optional(
        object({
          id   = optional(string)
          pool = optional(string)
        })
      )
      capacity = optional(
        object({
          min = optional(string)
          max = optional(string)
        })
      )
      parameters = optional(
        map(string),
        {}
      )
      capabilities = list(
        object({
          access_mode     = string
          attachment_mode = string
        })
      )
      constraints = optional(
        list(
          object({
            attribute = string
            operator  = optional(string, "=")
            value     = string
          })
        ),
        []
      )
    })
  )
  default = []
}
