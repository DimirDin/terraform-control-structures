# Создание виртуальных дисков
resource "yandex_compute_disk" "disks" {
  count = var.disk_count

  name     = "disk-${count.index + 1}"
  zone     = var.default_zone
  size     = var.disk_size
  type     = var.disk_type
}

# Создание ВМ storage с подключением дисков через dynamic
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores         = var.storage_resources.cores
    memory        = var.storage_resources.memory
    core_fraction = var.storage_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.storage_resources.disk_size
      type     = var.storage_resources.disk_type
    }
  }

  # Динамическое подключение дополнительных дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks
    content {
      disk_id = secondary_disk.value.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}
