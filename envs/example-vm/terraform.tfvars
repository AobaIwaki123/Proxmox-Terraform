hostname    = "example"
username    = "aoba"
public_key  = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBF5jwtylMTGVSpS/tWSHmnPLZH0eujjIRxOaZgwhw3dDCggs75WOKk8/NQS88fst4y/S+R8lUnIQGSN/qkQsciI= root@ansible"
cores       = 1
memory      = 4096
disk_size   = 64
ip_address  = "192.168.11.999"
gateway     = "192.168.11.1"
target_node = "pve02"
template    = "ubuntu-24.10a" # 任意のテンプレート名
storage     = "local-lvm"
bridge      = "vmbr0"
vmid       = 999 # IPアドレスの最後の数字に合わせる
