locals {
  dns      = "9.9.9.9"
  timezone = "UTC"
  hostname = "base"
  username = "admin"

  qemu_efi = {
    code = "/usr/share/OVMF/x64/OVMF_CODE.4m.fd"
    vars = "/usr/share/OVMF/x64/OVMF_VARS.4m.fd"
  }

  qemu_http_content = {
    "/alpine/answers.cfg" = templatefile("${path.root}/http/alpine/answers.pkrtpl.cfg", {
      dns      = local.dns
      hostname = local.hostname
      timezone = local.timezone
      username = local.username
    })
  }
}
