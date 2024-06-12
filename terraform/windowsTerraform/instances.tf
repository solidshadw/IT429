################ Windows 10 ######################################
resource "proxmox_vm_qemu" "windows10_vm" {
  count       = 1
  name        = "windows-10-computer"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_windows10

  pool     = "SOC-Class"
  tags     = "soc"
  agent    = 0
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 2
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  vmid     = 120


  ssh_user = "windy"

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
          size    = "120G"
        }
      }
    }
  }

  ipconfig0 = "ip=192.168.0.131/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }

  connection {
    type        = "ssh"
    user        = self.ssh_user
    private_key = file(var.private_ssh_key)
    host        = self.ssh_host
    port        = "22"
  }

  provisioner "file" {
    source      = "../wazy-ansible"
    destination = "C:/wazy-ansible"
    connection {
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "ipconfig"
    ]
  }
}

