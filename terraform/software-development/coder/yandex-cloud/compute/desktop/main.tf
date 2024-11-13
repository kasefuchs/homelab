terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

variable "yandex_availability_zone" {
  type        = string
  description = "The zone where operations will take place."
  default     = "ru-central1-d"
}

variable "yandex_token" {
  type        = string
  description = "The access token for API operations."
}

variable "yandex_cloud_id" {
  type        = string
  description = "ID of Yandex.Cloud tenant."
}

variable "yandex_folder_id" {
  type        = string
  description = "The folder ID where resources will be placed."
}

variable "yandex_subnet_id" {
  type        = string
  description = "ID of the subnet to attach vm instances to."
}

variable "yandex_disk_image_id" {
  type        = string
  default     = "fd8bcj8seh7cac9qsk8e"
  description = "Source image ID to use when creating the disk."
}

provider "coder" {}

provider "yandex" {
  zone      = var.yandex_availability_zone
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}

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

data "coder_workspace" "me" {}

data "coder_workspace_owner" "me" {}

resource "coder_agent" "agent" {
  arch = "amd64"
  os   = "linux"

  display_apps {
    vscode = false
  }

  metadata {
    key          = "cpu"
    display_name = "CPU Usage"
    interval     = 5
    timeout      = 5
    script       = "coder stat cpu"
  }

  metadata {
    key          = "memory"
    display_name = "Memory Usage"
    interval     = 5
    timeout      = 5
    script       = "coder stat mem"
  }

  metadata {
    key          = "home"
    display_name = "Disk Usage"
    interval     = 600
    timeout      = 30
    script       = "coder stat disk"
  }
}

module "personalize" {
  source   = "registry.coder.com/modules/personalize/coder"
  version  = "1.0.2"
  agent_id = coder_agent.agent.id

  log_path = "/tmp/personalize.log"
}

module "coder-login" {
  source   = "registry.coder.com/modules/coder-login/coder"
  version  = "1.0.15"
  agent_id = coder_agent.agent.id
}

module "git-config" {
  source   = "registry.coder.com/modules/git-config/coder"
  version  = "1.0.15"
  agent_id = coder_agent.agent.id

  allow_email_change    = false
  allow_username_change = false
}

module "git-commit-signing" {
  source   = "registry.coder.com/modules/git-commit-signing/coder"
  version  = "1.0.11"
  agent_id = coder_agent.agent.id
}

resource "random_password" "access_password" {
  length  = 16
  special = false
}

resource "coder_metadata" "access_password" {
  resource_id = random_password.access_password.id
  item {
    key       = "Password"
    value     = random_password.access_password.result
    sensitive = true
  }
}

resource "coder_app" "novnc" {
  agent_id = coder_agent.agent.id

  url          = "http://localhost:6080?autoconnect=1&resize=scale&path=@${data.coder_workspace_owner.me.name}/${data.coder_workspace.me.name}.${coder_agent.agent.id}/apps/novnc/websockify&password=${random_password.access_password.result}"
  slug         = "novnc"
  icon         = "${data.coder_workspace.me.access_url}/icon/novnc.svg"
  display_name = "noVNC"
}

resource "yandex_compute_disk" "disk" {
  name        = "coder-${data.coder_workspace.me.id}"
  description = "Disk provisioned for ${data.coder_workspace_owner.me.name}/${data.coder_workspace.me.name} Coder workspace."

  type     = data.coder_parameter.disk_type.value
  size     = data.coder_parameter.disk_size.value
  image_id = var.yandex_disk_image_id

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "yandex_compute_instance" "instance" {
  name        = "coder-${data.coder_workspace.me.id}"
  description = "Instance provisioned for ${data.coder_workspace_owner.me.name}/${data.coder_workspace.me.name} Coder workspace."

  count       = data.coder_workspace.me.start_count
  hostname    = lower(data.coder_workspace.me.name)
  platform_id = data.coder_parameter.platform_id.value

  allow_stopping_for_update = true

  metadata = {
    user-data = templatefile("cloud-init/user-data.tpl", {
      access_password            = random_password.access_password.result
      coder_agent_token          = coder_agent.agent.token
      coder_agent_init_script    = base64encode(coder_agent.agent.init_script)
      coder_workspace_owner_name = lower(data.coder_workspace_owner.me.name)
    })
    serial-port-enable = 1
  }

  boot_disk {
    disk_id     = yandex_compute_disk.disk.id
    auto_delete = false
  }

  network_interface {
    nat       = true
    subnet_id = var.yandex_subnet_id
  }

  resources {
    cores         = data.coder_parameter.cores.value
    memory        = data.coder_parameter.memory.value
    core_fraction = data.coder_parameter.core_fraction.value
  }

  scheduling_policy {
    preemptible = true
  }
}
