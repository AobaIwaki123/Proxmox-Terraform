variable "hostname" {
  description = "The hostname for the VM"
  type        = string
}

variable "public_key" {
  description = "The public SSH key for authentication"
  type        = list(string)
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Memory size in MB"
  type        = number
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
}

variable "ip_address" {
  description = "IP address for the VM"
  type        = string
}

variable "gateway" {
  description = "Gateway for the VM"
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to deploy the VM to"
  type        = string
}

variable "template" {
  description = "The template to clone the VM from"
  type        = string
}

variable "storage" {
  description = "The storage location for the VM"
  type        = string
}

variable "bridge" {
  description = "The network bridge for the VM"
  type        = string
}

variable "vmid" {
  description = "The VM ID"
  type        = number
}
