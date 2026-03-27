# VPC и Subnet для Web
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# Subnet для DB в зоне ru-central1-b
resource "yandex_vpc_subnet" "db" {
  name           = "${var.vpc_name}-db"
  zone           = var.db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [var.db_cidr]
}

# Data source для образа Ubuntu
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}
