variable "pm_api_url" {
  description = "value of the Proxmox API URL"
  type        = string
}

variable "pm_user" {
  description = "value of the Proxmox user"
  type        = string
}

variable "pm_api_token" {
  description = "value of the Proxmox API Token"
  type        = string
}

variable "pm_node" {
  description = "value of the Proxmox node"
  type        = string
}

variable "pm_pool" {
  description = "value of the Proxmox pool"
  type        = string
}

variable "pm_full_clone" {
  description = "value of the Proxmox full clone"
  type        = bool
}

# change this value with the id of your templates (win10 can be ignored if not used)
variable "vm_template_id" {
  description = "value of the Proxmox VM Template ID"
  type        = map(number)
  # set the ids according to your templates (only WinServer2019_x64 used in BYTEKINGDOM-light)
  default = { // this is the ID of the template you want to use
    "WinServer2019x64-cloudinit-raw" = 102
    "WinServer2016x64-cloudinit-raw" = 101
    "Windows10_22h2_x64"             = 0
  }
}

variable "storage" {
  description = "Name of your storage"
}

variable "network_bridge" {
  description = "Name of your network bridge"
  type        = string
}

variable "network_model" {
  description = "value of the network model"
  type        = string
}