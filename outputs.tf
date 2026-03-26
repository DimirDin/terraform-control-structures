output "all_vms_info" {
  value = {
    web = [
      for vm in yandex_compute_instance.web : {
        name       = vm.name
        id         = vm.id
        fqdn       = vm.fqdn
        external_ip = vm.network_interface[0].nat_ip_address
      }
    ]
    db = [
      for vm in yandex_compute_instance.db : {
        name       = vm.name
        id         = vm.id
        fqdn       = vm.fqdn
        external_ip = vm.network_interface[0].nat_ip_address
      }
    ]
    storage = {
      name       = yandex_compute_instance.storage.name
      id         = yandex_compute_instance.storage.id
      fqdn       = yandex_compute_instance.storage.fqdn
      external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    }
  }
  description = "Information about all VMs"
}

output "ansible_inventory_path" {
  value       = local_file.ansible_inventory.filename
  description = "Path to generated Ansible inventory file"
}
