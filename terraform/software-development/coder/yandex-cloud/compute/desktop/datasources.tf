data "coder_workspace" "me" {}

data "coder_workspace_owner" "me" {}

data "coder_parameter" "platform_id" {
  icon         = "/emojis/1f689.png"
  name         = "platform_id"
  display_name = "Platform"
  description  = "Specifies platform for the instance."

  type    = "string"
  default = "standard-v3"
  mutable = true

  option {
    icon  = "/emojis/1f5a5.png"
    name  = "Intel Broadwell"
    value = "standard-v1"
  }

  option {
    icon  = "/emojis/1f5a5.png"
    name  = "Intel Cascade Lake"
    value = "standard-v2"
  }

  option {
    icon  = "/emojis/1f5a5.png"
    name  = "Intel Ice Lake"
    value = "standard-v3"
  }

  option {
    icon  = "/emojis/1f5a5.png"
    name  = "Intel Ice Lake (Compute-Optimized)"
    value = "highfreq-v3"
  }
}

data "coder_parameter" "cores" {
  icon         = "/emojis/1f525.png"
  name         = "cores"
  display_name = "Number of cores"
  description  = "Specifies how many CPU cores workspace should have."

  type    = "number"
  default = 2
  mutable = true
}

data "coder_parameter" "memory" {
  icon         = "/emojis/1f9e0.png"
  name         = "memory"
  display_name = "Amount of memory"
  description  = "Specifies how much memory workspace should have."

  type    = "number"
  default = 1
  mutable = true
}

data "coder_parameter" "core_fraction" {
  icon         = "/emojis/1f680.png"
  name         = "core_fraction"
  display_name = "Core fraction"
  description  = "Specifies baseline performance for a core in percent."

  type    = "number"
  default = 50
  mutable = true
}

data "coder_parameter" "disk_type" {
  icon         = "/emojis/1f4bd.png"
  name         = "disk_type"
  display_name = "Disk type"
  description  = "Specifies the type of the disk."

  type    = "string"
  default = "network-hdd"
  mutable = false

  option {
    icon  = "/emojis/1f422.png"
    name  = "HDD"
    value = "network-hdd"
  }

  option {
    icon  = "/emojis/1f408.png"
    name  = "SSD"
    value = "network-ssd"
  }

  option {
    icon  = "/emojis/1f406.png"
    name  = "SSD IO"
    value = "network-ssd-io-m3"
  }

  option {
    icon  = "/emojis/1f408-200d-2b1b.png"
    name  = "Non-replicated SSD"
    value = "network-ssd-nonreplicated"
  }
}

data "coder_parameter" "disk_size" {
  icon         = "/emojis/1f4be.png"
  name         = "disk_size"
  display_name = "Disk size"
  description  = "Specifies the size of the disk in GB."

  type    = "number"
  default = 10
  mutable = true
}
