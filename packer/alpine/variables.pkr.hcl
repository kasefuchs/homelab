variable "source" {
  type = object({
    url      = string
    checksum = string
  })

  default = {
    url      = "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-virt-3.22.2-x86_64.iso"
    checksum = "sha256:b6c45d69829b1b0416ada798353805099d57b8bef9093b85a8319fe5373595d5"
  }
}

variable "boot" {
  type = object({
    efi          = bool
    wait         = string
    command      = list(string)
    key_interval = string
  })

  default = {
    efi  = true
    wait = "10s"
    # noinspection HttpUrlsUsage
    command = [
      # Login
      "root<enter><wait>",

      # Configure network
      "ifconfig eth0 up && udhcpc -i eth0<enter><wait>",

      # Setup Alpine
      "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers.cfg<enter><wait>",
      "echo 'USERSSHKEY=\"{{ .SSHPublicKey }}\"' >> answers.cfg<enter>",
      "setup-alpine -f answers.cfg<enter><wait10>",

      # Root password
      "<enter><wait><enter><wait10>",

      # Disk & Install
      "y<enter><wait30s>",

      # Stop SSH daemon
      "rc-service sshd stop<enter>",

      # Add boot entry
      "apk add --no-cache efibootmgr<enter><wait5>",
      "efibootmgr --create --disk /dev/vda --part 1 --label 'Alpine' --loader '\\EFI\\alpine\\grubx64.efi'<enter><wait>",

      # Reboot
      "reboot<enter>"
    ]
    key_interval = "5ms"
  }
}

variable "resources" {
  type = object({
    cpus        = number
    memory      = number
    disk_size   = string
    headless    = bool
    accelerator = string
  })

  default = {
    cpus        = 2
    memory      = 1024
    disk_size   = "5G"
    headless    = true
    accelerator = "kvm"
  }
}
