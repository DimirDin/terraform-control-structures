# Переменная для ВМ БД
variable "each_vm" {
  type = list(object({
    vm_name      = string
    cpu          = number
    ram          = number
    disk_volume  = number
    zone         = string
    platform_id  = string
    disk_type    = string
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 4
      disk_volume = 20
      zone        = "ru-central1-a"
      platform_id = "standard-v1"
      disk_type   = "network-ssd"
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 15
      zone        = "ru-central1-b"
      platform_id = "standard-v1"
      disk_type   = "network-ssd"
    }
  ]
}

# Создание ВМ БД с помощью for_each
resource "yandex_compute_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = each.value.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
      type     = each.value.disk_type
    }
  }

  network_interface {
    subnet_id = each.value.zone == var.default_zone ? yandex_vpc_subnet.develop.id : yandex_vpc_subnet.db.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_key}"
  }
}
