provider "yandex" {
  zone      = var.yandex_availability_zone
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}
