###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

### VM Resources variables

variable "web_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 5
    disk_size     = 10
    disk_type     = "network-hdd"
  }
  description = "Resources for web VMs"
}

variable "db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Zone for DB VMs"
}

variable "db_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR for DB subnet"
}

### Disk variables

variable "disk_count" {
  type        = number
  default     = 3
  description = "Number of disks for storage VM"
}

variable "disk_size" {
  type        = number
  default     = 1
  description = "Size of each disk in GB"
}

variable "disk_type" {
  type        = string
  default     = "network-hdd"
  description = "Type of disk"
}

### Storage VM resources

variable "storage_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 5
    disk_size     = 10
    disk_type     = "network-hdd"
  }
  description = "Resources for storage VM"
}

### Inventory file path

variable "inventory_path" {
  type        = string
  default     = "./inventory.cfg"
  description = "Path to generated Ansible inventory file"
}
