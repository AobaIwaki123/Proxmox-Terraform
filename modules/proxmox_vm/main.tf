resource "proxmox_vm_qemu" "vm" {
  name       = var.hostname
  target_node = var.target_node
  clone       = var.template
  os_type     = "cloud-init"
  boot        = "order=virtio0"

  cores   = var.cores
  memory  = var.memory

  disks {
    ide { # CloudInitの設定を書き込むためのディスク
      ide2 {
        cloudinit {
          storage = var.storage
        }
      }
    }
    virtio { # データ用のディスク
      virtio0 {
        disk {
          size = "${var.disk_size}G"
          storage = var.storage
        }
      }
    }
  }
  
  network {
    id = 0
    model    = "virtio"
    bridge   = var.bridge
    firewall = false
  }

  ipconfig0 = "ip=${var.ip_address}/24,gw=${var.gateway}"
  ciuser    = var.username
  sshkeys   = join("\n", var.public_key)
  vmid = var.vmid
}
