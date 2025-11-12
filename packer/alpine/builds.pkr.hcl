build {
  sources = ["qemu.image"]

  post-processor "vagrant" {
    output              = "${local.output}/${local.hostname}.box"
    compression_level   = 6
    keep_input_artifact = true
  }
}
