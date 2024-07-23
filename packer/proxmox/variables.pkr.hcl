variable "proxmox_url" {
  description = "The URL to access the Proxmox server."
  type        = string
}

variable "proxmox_username" {
  description = "The username for Proxmox authentication."
  type        = string
}

variable "proxmox_token" {
  description = "The API token for Proxmox authentication."
  type        = string
}

variable "proxmox_skip_tls_verify" {
  description = "Skip TLS verification when connecting to Proxmox."
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "The name of the Proxmox node."
  type        = string
}

variable "proxmox_pool" {
  description = "The name of the Proxmox resource pool."
  type        = string
  default     = ""
}

variable "proxmox_vm_storage" {
  description = "The storage pool for VM disks in Proxmox."
  type        = string
}

variable "proxmox_iso_storage" {
  description = "The storage pool for ISO files in Proxmox."
  type        = string
}

variable "winrm_username" {
  description = "The WinRM username to connect to the guest."
  type        = string
  default     = ""
}

variable "winrm_password" {
  description = "The WinRM password to connect to the guest."
  type        = string
  default     = ""
}

variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "template_description" {
  description = "The description for the VM template."
  type        = string
  default     = ""
}

variable "iso_file" {
  description = "The name of the ISO file."
  type        = string
}

variable "autounattend_iso" {
  description = "The autounattend ISO file for automated installation."
  type        = string
  default     = ""
}

variable "autounattend_checksum" {
  description = "The checksum of the autounattend ISO file."
  type        = string
  default     = ""
}

variable "vm_cpu_cores" {
  description = "The number of CPU cores for the VM."
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "The amount of memory for the VM in Megabytes."
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "The size of the VM disk."
  type        = string
  default     = "50G"
}

variable "vm_disk_format" {
  description = "The format of the VM disk."
  type        = string
  default     = "qcow2"
}

variable "vm_sockets" {
  description = "The number of CPU sockets for the VM."
  type        = number
  default     = 1
}

variable "os" {
  description = "The operating system of the VM."
  type        = string
  default     = "linux"
}

# variable "boot" {
#   type = string
# }
# variable "bios_type" {
#   type = string
# }
# variable "boot_command" {
#   type = string
# }
# variable "boot_wait" {
#   type = string
# }
# variable "bridge_firewall" {
#   type    = bool
#   default = false
# }
# variable "bridge_name" {
#   type = string
# }
# variable "cloud_init" {
#   type = bool
# }
# variable "cpu_type" {
#   type    = string
#   default = "host"
# }
# variable "disk_discard" {
#   type    = bool
#   default = true
# }
# variable "disk_format" {
#   type    = string
#   default = "qcow2"
# }
# variable "disk_size" {
#   type    = string
#   default = "16G"
# }
# variable "disk_type" {
#   type    = string
#   default = "scsi"
# }
# variable "io_thread" {
#   type = bool
# }
# variable "iso_storage_pool" {
#   type    = string
#   default = "local"
# }
# variable "machine_default_type" {
#   type    = string
#   default = "pc"
# }
# variable "nb_core" {
#   type    = number
#   default = 1
# }
# variable "nb_cpu" {
#   type    = number
#   default = 1
# }
# variable "nb_ram" {
#   type    = number
#   default = 1024
# }
# variable "network_model" {
#   type    = string
#   default = "virtio"
# }
# variable "os_type" {
#   type    = string
#   default = "l26"
# }
# variable "qemu_agent_activation" {
#   type    = bool
#   default = true
# }
# variable "scsi_controller_type" {
#   type = string
# }
# variable "ssh_handshake_attempts" {
#   type = number
# }
# variable "ssh_password" {
#   type = string
# }
# variable "ssh_timeout" {
#   type = string
# }
# variable "ssh_username" {
#   type = string
# }
# variable "storage_pool" {
#   type = string
# }
# variable "tags" {
#   type = string
# }
# variable "vm_info" {
#   type = string
# }
# variable "vm_id" {
#   type    = number
#   default = 9999
# }
# variable "http_port_max" {
#   type = string
# }
# variable "http_port_min" {
#   type = string
# }