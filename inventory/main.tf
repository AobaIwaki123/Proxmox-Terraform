terraform {
  required_version = ">= 1.3.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

module "vm" {
  for_each = var.vms
  source   = "../modules/proxmox_vm"

  hostname     = each.key
  username     = var.defaults.username
  public_key   = var.defaults.public_key
  cores        = each.value.cores
  memory       = each.value.memory
  disk_size    = each.value.disk_size
  ip_address   = each.value.ip_address
  gateway      = var.defaults.gateway
  nameserver   = var.defaults.nameserver
  searchdomain = var.defaults.searchdomain
  target_node  = each.value.target_node
  template     = var.defaults.template
  storage      = var.defaults.storage
  bridge       = var.defaults.bridge
  vmid         = each.value.vmid
}
