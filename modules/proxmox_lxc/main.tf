resource "proxmox_lxc" "basic" {
  features {
      nesting = true
  }
  
  vmid = var.vmid
  target_node  = var.target_node
  hostname     = var.hostname
  ssh_public_keys = join("\n", var.public_key)

  ostemplate   = "local:vztmpl/${var.template}.tar.zst"

  cores  = var.cores
  memory = var.memory

  unprivileged = true
  start       = true

  // Terraform will crash without rootfs defined
  rootfs {
    storage = var.storage
    size    = "${var.disk_size}G"
  }

    network {
        name = "eth0"
        bridge = var.bridge
        ip = "${var.ip_address}/24"
        gw = var.gateway
    }
}
