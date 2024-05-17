
resource "proxmox_vm_qemu" "ubuntu_cloud_vm" {
  count       = 2
  name        = "ubuntu-cloud-vm-${count.index + 1}"
  target_node = var.target_node
  desc        = "Cloudinit Ubuntu"
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  os_type  = "cloud-init"
  pool     = "SOC-Class"
  cores    = 2
  sockets  = 1
  memory   = 4096
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser   = "ubuntu"
  sshkeys  = <<EOF
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMCTs3S+7VmDFEWADMwE6eBf5TL3CD/kIK9DbFA0JO2 ansy@ansibleserver
  EOF

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.0.11${count.index + 1}/24,gw=192.168.0.1"

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = 60
        }
      }
    }
  }

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }
}