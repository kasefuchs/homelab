variable "vagrant" {
  type = object({
    provider        = string
    source_path     = string
    source_skip_add = bool
  })

  default = {
    provider        = "libvirt"
    source_path     = "generic/debian12"
    source_skip_add = true
  }
}
