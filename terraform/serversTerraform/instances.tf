############################################
########## Ubuntu Server Linux VM ##########
############################################

resource "proxmox_vm_qemu" "ubuntu_vm" {
  count       = 2
  name        = "ubuntu-vm-${count.index + 1}"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  os_type                 = "cloud-init"
  cores                   = 2
  sockets                 = 1
  memory                  = 4096
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  ciuser                  = "ubuntu"
  #cipassword              = "ubuntu" # If you want to add a default password
  sshkeys = file(var.public_ssh_key)

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "80G"
        }
      }
    }
  }

  ipconfig0 = "ip=${count.index + 1}/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }
}


###################################
########## Kali Linux VM ##########
###################################

# resource "proxmox_vm_qemu" "kali_vm" {
#   count       = 2
#   name        = "kali-vm-${count.index + 1}"
#   target_node = var.target_node
#   onboot      = true

#   # The template name to clone this VM from
#   clone = var.template_name_kali

#   os_type                 = "cloud-init"
#   cores                   = 4
#   sockets                 = 2
#   memory                  = 8192
#   cloudinit_cdrom_storage = "local-lvm"
#   scsihw                  = "virtio-scsi-single"
#   bootdisk                = "scsi0"
#   sshkeys = <<EOF
#   ${var.ssh_key}s
#   EOF

  # disks {
  #   ide {
  #     ide2 {
  #       cloudinit {
  #         storage = "local-lvm"
  #       }
  #     }
  #   }
  #   scsi {
  #     scsi0 {
  #       disk {
  #         storage = "local-lvm"
  #         size    = "80G"
  #       }
  #     }
  #   }
  # }

#   ipconfig0 = "ip=192.168.0.10${count.index + 1}/24,gw=192.168.0.1"

#   vga {
#     type = "std"
#     #Between 4 and 512, ignored if type is defined to serial
#     memory = 4
#   }
# }