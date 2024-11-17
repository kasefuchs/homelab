variable "yandex_availability_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "The zone where operations will take place."
}

variable "yandex_token" {
  type        = string
  sensitive   = true
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
  description = "Source image ID to use when creating the disk."
}
