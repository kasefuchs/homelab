variable "dynamic_host" {
  type = list(
    object({
      name      = string
      plugin    = string
      namespace = optional(string, "default")
      node = optional(
        object({
          id   = string
          pool = string
        })
      )
      capacity = optional(
        object({
          min = string
          max = string
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
