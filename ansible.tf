# Локальная переменная для формирования inventory
locals {
  webservers = [
    for vm in yandex_compute_instance.web : {
      name              = vm.name
      network_interface = vm.network_interface
      fqdn              = vm.fqdn
    }
  ]

  databases = [
    for vm in yandex_compute_instance.db : {
      name              = vm.name
      network_interface = vm.network_interface
      fqdn              = vm.fqdn
    }
  ]

  storage = {
    name              = yandex_compute_instance.storage.name
    network_interface = yandex_compute_instance.storage.network_interface
    fqdn              = yandex_compute_instance.storage.fqdn
  }
}

# Создание ansible inventory файла
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = local.webservers
    databases  = local.databases
    storage    = local.storage
  })
  filename = var.inventory_path
}
