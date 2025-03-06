module "proxmox_lxc" {
    source     = "../../modules/proxmox_lxc"
    hostname   = var.hostname
    public_key  = var.public_key
    cores       = var.cores
    memory      = var.memory
    disk_size   = var.disk_size
    ip_address  = var.ip_address
    gateway     = var.gateway
    target_node = var.target_node
    template    = var.template
    storage     = var.storage
    bridge      = var.bridge
    vmid        = var.vmid
}
