variable "defaults" {
  description = "VM 間で共通の設定"
  type = object({
    username     = string
    public_key   = list(string)
    gateway      = string
    nameserver   = string
    searchdomain = string
    template     = string
    storage      = string
    bridge       = string
  })
}

variable "vms" {
  description = "ホスト名をキーとする VM の一覧"
  type = map(object({
    vmid        = number
    target_node = string
    ip_address  = string
    cores       = number
    memory      = number
    disk_size   = number
  }))
}
