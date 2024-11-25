resource "proxmox_lxc" "basic" {
  features {
      nesting = true
  }
  
  target_node  = "pve02"
  hostname     = "lxc-basic"
  unprivileged = true
  ostemplate   = "local:vztmpl/ubuntu-24.10-standard_24.10-1_amd64.tar.zst"
  
  vmid = 240
  swap = 512
  start = true
  ssh_public_keys = <<-EOT
    ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAFENRdM4NwJfgRO/MqntSOLZxSy0fTLkj0etUL/CnakA7gNI9YuZUYQxtGVa80Oc+6bZjT38Nd6Eico5RoRVAdlzwEEfQq+iy3v/W8c0ElybiSQmPIw7Mc7KaEyUhMb1LgmVleZYsEizJV/89/lNGvPVjUXkcEZsliIMROuFepQASUiuQ== iwakiaoiyou@AobaMacBookAir.local
  EOT

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.11.240/24"
        ip6 = "dhcp"
    }
}
