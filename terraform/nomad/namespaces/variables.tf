variable "namespaces" {
  type = list(
    object({
      name        = string
      description = optional(string)
      meta        = optional(map(string))
      capabilities = optional(
        object({
          task_drivers = optional(
            object({
              enabled  = optional(list(string))
              disabled = optional(list(string))
            })
          )
        })
      )
    })
  )
  default = [
    {
      name        = "default",
      description = "Default shared namespace"
    }
  ]
}
