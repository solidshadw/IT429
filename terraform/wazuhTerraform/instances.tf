################ Ansible Server ######################################
resource "proxmox_vm_qemu" "ubuntu_vm_ansible_server" {
  count       = 1
  name        = "ubuntu-ansible-server"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  pool     = "SOC-Class"
  agent    = 0
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 2
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"


  ssh_user = "ubuntu"

  sshkeys = <<EOF
  ${var.public_ssh_key}
  EOF

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

  ipconfig0 = "ip=192.168.0.120/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }

  connection {
    type        = "ssh"
    user        = self.ssh_user
    private_key = file(var.private_ssh_key)
    host        = "192.168.0.120"
    port        = "22"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y ansible",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "sudo chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 700 /home/ubuntu/.ssh",
      "echo '${var.private_ssh_key}' | sudo tee -a /home/ubuntu/.ssh/id_ed25519",
      "echo '${var.public_ssh_key}' | sudo tee -a /home/ubuntu/.ssh/id_ed25519.pub",
      "sudo chmod 600 /home/ubuntu/.ssh/id_ed25519",
      "sudo chmod 644 /home/ubuntu/.ssh/id_ed25519.pub",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg"
    ]
  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "sleep 60 && sudo ansible-playbook --become -i ${var.ansible_inventory} ${var.ansible_playbook}"
    }
  }

################ Wazuh Cluster Ubuntu Server Linux VM ################

resource "proxmox_vm_qemu" "ubuntu_vm_indexers" {
  count       = 3
  name        = "ubuntu-wazuh-indexers-${count.index + 1}"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  pool  = "SOC-Class"
  agent = 0

  os_type                 = "cloud-init"
  cores                   = 2
  sockets                 = 2
  memory                  = 8192
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  ciuser                  = "ubuntu"
  #cipassword              = "ubuntu" # If you want to add a default password
  sshkeys = <<EOF
  ${var.public_ssh_key}
  EOF

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
          size    = "250G"
        }
      }
    }
  }

  ipconfig0 = "ip=192.168.0.10${count.index + 3}/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }
}

# ################ Wazuh Nodes Ubuntu Server Linux VM ###################

resource "proxmox_vm_qemu" "ubuntu_vm_node1" {
  count       = 1
  name        = "ubuntu-wazuh-manager"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  pool  = "SOC-Class"
  agent = 0

  os_type                 = "cloud-init"
  cores                   = 2
  sockets                 = 2
  memory                  = 8192
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  ciuser                  = "ubuntu"
  #cipassword              = "ubuntu" # If you want to add a default password
  sshkeys = <<EOF
  ${var.public_ssh_key}
  EOF

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

  ipconfig0 = "ip=192.168.0.101/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }
}

resource "proxmox_vm_qemu" "ubuntu_vm_node2" {
  count       = 1
  name        = "ubuntu-wazuh-worker"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  pool  = "SOC-Class"
  agent = 0

  os_type                 = "cloud-init"
  cores                   = 2
  sockets                 = 2
  memory                  = 8192
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  ciuser                  = "ubuntu"
  #cipassword              = "ubuntu" # If you want to add a default password
  sshkeys = <<EOF
  ${var.public_ssh_key}
  EOF

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

  ipconfig0 = "ip=192.168.0.102/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }
}

# ################ Wazuh Dashboard Ubuntu Server Linux VM ###################

resource "proxmox_vm_qemu" "ubuntu_vm_dashboard" {
  count       = 1
  name        = "ubuntu-wazuh-dashboard"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

  pool  = "SOC-Class"
  agent = 0

  os_type                 = "cloud-init"
  cores                   = 2
  sockets                 = 2
  memory                  = 8192
  scsihw                  = "virtio-scsi-single"
  bootdisk                = "scsi0"
  ciuser                  = "ubuntu"
  #cipassword              = "ubuntu" # If you want to add a default password
  sshkeys = <<EOF
  ${var.public_ssh_key}
  EOF

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

  ipconfig0 = "ip=192.168.0.100/24,gw=192.168.0.1"

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }
}