source "qemu" "image" {
  iso_url      = var.source.url
  iso_checksum = var.source.checksum

  cpus        = var.resources.cpus
  memory      = var.resources.memory
  disk_size   = var.resources.disk_size
  disk_image  = var.resources.disk_image
  headless    = var.resources.headless
  accelerator = var.resources.accelerator

  http_content     = local.http
  output_directory = local.output

  boot_wait         = var.boot.wait
  boot_command      = var.boot.command
  boot_key_interval = var.boot.key_interval

  efi_boot          = var.boot.efi
  efi_drop_efivars  = var.boot.efi
  efi_firmware_code = local.efi.code
  efi_firmware_vars = local.efi.vars

  ssh_username            = local.username
  temporary_key_pair_type = "ed25519"
}
