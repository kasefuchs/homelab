variable "yandex_availability_zone" {
  type        = string
  description = "The zone where operations will take place."
}

variable "yandex_token" {
  type        = string
  description = "The access token for API operations."
}

variable "yandex_folder_id" {
  type        = string
  description = "The folder ID where resources will be placed."
}

variable "yandex_subnet_id" {
  type        = string
  description = "ID of the subnet to attach vm instances to."
}

variable "yandex_image_name" {
  type        = string
  default     = "coder-debian-12-{{timestamp}}"
  description = "The name of the resulting image."
}

variable "yandex_image_family" {
  type        = string
  default     = "coder-debian-12"
  description = "The family name of the image."
}

variable "yandex_source_image_family" {
  type        = string
  default     = "debian-12"
  description = "The source image family to create the new image from."
}
