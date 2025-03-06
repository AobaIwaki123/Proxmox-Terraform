hostname    = "cloudflare"
public_key  = "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAFENRdM4NwJfgRO/MqntSOLZxSy0fTLkj0etUL/CnakA7gNI9YuZUYQxtGVa80Oc+6bZjT38Nd6Eico5RoRVAdlzwEEfQq+iy3v/W8c0ElybiSQmPIw7Mc7KaEyUhMb1LgmVleZYsEizJV/89/lNGvPVjUXkcEZsliIMROuFepQASUiuQ== iwakiaoiyou@AobaMacBookAir.local"
cores       = 1
memory      = 1024
disk_size   = 32
ip_address  = "192.168.11.241"
gateway     = "192.168.11.1"
target_node = "pve02"
template    = "ubuntu-24.10-standard_24.10-1_amd64" # 任意のテンプレート名
storage     = "local-lvm"
bridge      = "vmbr0"
vmid       = 241 # IPアドレスの最後の数字に合わせる
