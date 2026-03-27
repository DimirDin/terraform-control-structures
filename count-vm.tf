# Создание двух одинаковых ВМ с помощью count
# Имена: web-1 и web-2 (не web-0 и web-1)

locals {
  ssh_key = file("~/.ssh/id_ed25519.pub")
}

resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores         = var.web_resources.cores
    memory        = var.web_resources.memory
    core_fraction = var.web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.web_resources.disk_size
      type     = var.web_resources.disk_type
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

  # Зависимость от ВМ БД (создаются после)
  depends_on = [yandex_compute_instance.db]
}
