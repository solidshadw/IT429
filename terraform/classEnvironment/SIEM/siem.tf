## TESTING TO HAVE SAME PROVIDERS, WILL BE UPDATING....


# variable "vm_config" {
#   type = map(object({
#     name    = string
#     desc    = string
#     cores   = number
#     memory  = number
#     clone   = string
#     dns     = string
#     ip      = string
#     gateway = string
#   }))

#   default = {
#     "ansible-server" = {
#       name    = "ansible-server"
#       desc    = "ANSIBLE SERVER - Ubuntu - 192.168.0.120"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.120/24"
#       gateway = "192.168.0.1"
#     }
#     "caldera-server" = {
#       name    = "caldera-server"
#       desc    = "Caldera SERVER - Ubuntu - 192.168.0.130"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.130/24"
#       gateway = "192.168.0.1"
#     }
#     "wazuh-indexer1" = {
#       name    = "wazuh-indexer1"
#       desc    = "SRV02 - windows server 2019 - 192.168.0.103"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.103/24"
#       gateway = "192.168.0.1"
#     }
#     "wazuh-indexer2" = {
#       name    = "wazuh-indexer2"
#       desc    = "DC01 - windows server 2019 - 192.168.0.104"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.104/24"
#       gateway = "192.168.0.1"
#     }
#     "wazuh-indexer3" = {
#       name    = "wazuh-indexer3"
#       desc    = "DC02 - windows server 2019 - 192.168.0.105"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.105/24"
#       gateway = "192.168.0.1"
#     }
#     "wazuh-manager" = {
#       name    = "wazuh-manager"
#       desc    = "SRV02 - windows server 2019 - 192.168.0.101"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.101/24"
#       gateway = "192.168.0.1"
#     }
#     "wazuh-worker" = {
#       name    = "wazuh-worker"
#       desc    = "SRV02 - windows server 2019 - 192.168.0.102"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.102/24"
#       gateway = "192.168.0.1"
#     }
#     "srv02" = {
#       name    = "wazuh-dashboard"
#       desc    = "SRV02 - windows server 2019 - 192.168.0.100"
#       cores   = 2
#       memory  = 8192
#       clone   = "ubuntu-template"
#       dns     = "192.168.0.1"
#       ip      = "192.168.0.100/24"
#       gateway = "192.168.0.1"
#     }
#   }
# }

# resource "proxmox_virtual_environment_vm" "bytekingdom" {
#   for_each = var.vm_config

#   name        = each.value.name
#   description = each.value.desc
#   tags        = ["soc"]
#   node_name   = var.pm_node
#   pool_id     = var.pm_pool
#   scsi_hardware = var.scsihw
#   stop_on_destroy = true


#   operating_system {
#     type = "l26"
#   }

#   cpu {
#     cores   = each.value.cores
#     sockets = 2
#   }

#   memory {
#     dedicated = each.value.memory
#   }

#   clone {
#     vm_id   = lookup(var.vm_template_id, each.value.clone, -1)
#     full    = var.pm_full_clone
#     retries = 2
#   }

#   agent {
#     # read 'Qemu guest agent' section, change to true only when ready
#     enabled = true
#   }
  

#   network_device {
#     bridge = var.network_bridge
#     model  = var.network_model
#   }

#   lifecycle {
#     ignore_changes = [
#       vga,
#     ]
#   }

#   initialization {
#     datastore_id = var.storage
#     interface = var.interface

#     dns {
#       servers = [
#         each.value.dns
#       ]
#     }
#     ip_config {
#       ipv4 {
#         address = each.value.ip
#         gateway = each.value.gateway
#       }
#     }

#     user_account {
#       keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
#       password = random_random_password.ubuntu_vm_password.result
#       username = "ubuntu"
#     }
#   }
# }

# resource "random_password" "ubuntu_vm_password" {
#   length           = 16
#   override_special = "_%@"
#   special          = true
# }

# resource "tls_private_key" "ubuntu_vm_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# output "ubuntu_vm_password" {
#   value     = random_password.ubuntu_vm_password.result
#   sensitive = true
# }

# output "ubuntu_vm_private_key" {
#   value     = tls_private_key.ubuntu_vm_key.private_key_pem
#   sensitive = true
# }

# output "ubuntu_vm_public_key" {
#   value = tls_private_key.ubuntu_vm_key.public_key_openssh
# }