source "qemu" "image" {
  iso_url      = var.qemu_source.url
  iso_checksum = var.qemu_source.checksum

  cpus        = var.qemu_resources.cpus
  memory      = var.qemu_resources.memory
  disk_size   = var.qemu_resources.disk_size
  headless    = var.qemu_resources.headless
  accelerator = var.qemu_resources.accelerator

  boot_wait         = var.qemu_boot.wait
  boot_command      = var.qemu_boot.command
  boot_key_interval = var.qemu_boot.key_interval

  efi_boot          = var.qemu_boot.efi
  efi_firmware_code = local.qemu_efi.code
  efi_firmware_vars = local.qemu_efi.vars

  http_content = local.qemu_http_content

  ssh_username            = local.username
  temporary_key_pair_type = "ed25519"
}
