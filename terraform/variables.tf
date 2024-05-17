variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox Secret Token"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox Token ID"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "TLS Insecure"
  type        = bool
  default     = true
}

variable "target_node" {
  description = "Proxmox Target Node"
  type        = string
}

variable "template_name_ubuntu" {
  description = "Template VM ID to clone from"
  type        = string
}

variable "vm_name" {
  description = "Name of the new VM"
  type        = string
}