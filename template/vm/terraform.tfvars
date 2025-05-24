hostname    = "example"
username    = "aoba"
public_key  = [
  "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIyxcxWt4PUyistoRCACnzycvyL6yi1FO0N1x0XS/Ilaexy5W0Gx0FF64rr0jbrxPKTNb3o2yS/q7jhitJwhIsQ= iwakiaoiyou@iwakiaohanoMacBook-Air.local",
  "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE3S1IwZPPlvvhv8hCRjge+3oTtVVLgOMlClrQoiXLcHS17QB8iISNOdj6j9M1GJWtCXpMhN6Vm/lyrkncdI9co= root@ansible"
  ]
cores       = 1
memory      = 1024
disk_size   = 64
ip_address  = "192.168.11.999"
gateway     = "192.168.11.1"
nameserver  = "192.168.11.1"
searchdomain = "local"
target_node = "pve201"
template    = "ubuntu-24.10a" # 任意のテンプレート名
storage     = "local-lvm"
bridge      = "vmbr0"
vmid       = 999 # IPアドレスの最後の数字に合わせる
