variable "availability_zone" {
  type        = string
  description = "The zone where operations will take place."
}

variable "token" {
  type        = string
  description = "The access token for API operations."
}

variable "folder_id" {
  type        = string
  description = "The folder ID where resources will be placed."
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to attach vm instances to."
}

variable "ssh_username" {
  type        = string
  description = "The username to connect to SSH with."
  default     = "debian"
}

variable "disk_type" {
  type        = string
  description = "Specify disk type for the launched instance."
  default     = "network-ssd"
}

variable "disk_size" {
  type        = number
  description = "The size of the disk in GB."
  default     = 5
}

variable "image_name" {
  type        = string
  default     = "coder-desktop-debian-12-{{ timestamp }}"
  description = "The name of the resulting image."
}

variable "source_image_id" {
  type        = string
  description = "The source image family to create the new image from."
}
