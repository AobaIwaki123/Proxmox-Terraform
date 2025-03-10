hostname    = "example-lxc"
public_key  = [
  "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIyxcxWt4PUyistoRCACnzycvyL6yi1FO0N1x0XS/Ilaexy5W0Gx0FF64rr0jbrxPKTNb3o2yS/q7jhitJwhIsQ= iwakiaoiyou@iwakiaohanoMacBook-Air.local",
  "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBjSSH09KDRoHPVMjNA0Huj0rw+uoZmmyD6EkuHJKWG5mXolDeFyka8CaJvW3DRWWKLB5kIwW5HeUoNqE0kN+lg= root@ansible"
  ]
cores       = 1
memory      = 1024
disk_size   = 32
ip_address  = "192.168.11.999"
gateway     = "192.168.11.1"
target_node = "pve201"
template    = "ubuntu-24.10-standard_24.10-1_amd64" # 任意のテンプレート名
storage     = "local-lvm"
bridge      = "vmbr0"
vmid       = 999 # IPアドレスの最後の数字に合わせる
