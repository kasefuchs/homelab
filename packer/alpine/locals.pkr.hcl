locals {
  output = "output-image"

  dns      = "9.9.9.9"
  timezone = "UTC"
  username = "admin"
  hostname = "alpine"

  efi = {
    code = "/usr/share/OVMF/x64/OVMF_CODE.4m.fd"
    vars = "/usr/share/OVMF/x64/OVMF_VARS.4m.fd"
  }

  http = {
    "/answers.cfg" = templatefile("${path.root}/http/answers.pkrtpl.cfg", {
      dns      = local.dns
      hostname = local.hostname
      timezone = local.timezone
      username = local.username
    })
  }
}
