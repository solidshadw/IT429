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

variable "template_name_kali" {
  description = "Template VM ID to clone from"
  type        = string
}

variable "public_ssh_key" {
  description = "SSH Key"
  type        = string
}

variable "private_ssh_key" {
  description = "SSH Key"
  type        = string
}

variable "ansible_config" {
  description = "Ansible Config"
  type        = string
}

variable "ansible_playbook" {
  description = "Ansible Playbook"
  type        = string
}

variable "ansible_inventory" {
  description = "Ansible Inventory"
  type        = string
}