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
  vm_state     = each.value.vm_state
  username     = coalesce(each.value.username, var.defaults.username)
  public_key   = each.value.public_key != null ? each.value.public_key : var.defaults.public_key
  cores        = each.value.cores
  memory       = each.value.memory
  disk_size    = each.value.disk_size
  ip_address   = each.value.ip_address
  gateway      = coalesce(each.value.gateway, var.defaults.gateway)
  nameserver   = coalesce(each.value.nameserver, var.defaults.nameserver)
  searchdomain = coalesce(each.value.searchdomain, var.defaults.searchdomain)
  target_node  = each.value.target_node
  template     = coalesce(each.value.template, var.defaults.template)
  storage      = coalesce(each.value.storage, var.defaults.storage)
  bridge       = coalesce(each.value.bridge, var.defaults.bridge)
  vmid         = each.value.vmid
}
