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
    user-data = templatefile("${path.module}/cloud-init/user-data.tpl", {
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
