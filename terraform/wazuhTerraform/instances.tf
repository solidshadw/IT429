################ Ansible Server ######################################
resource "proxmox_vm_qemu" "ubuntu_vm_ansible_server" {
  count       = 1
  name        = "ubuntu-ansible-server"
  target_node = var.target_node
  onboot      = true

  # The template name to clone this VM from
  clone = var.template_name_ubuntu

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


  ssh_user = "ubuntu"

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
    host        = self.ssh_host
    port        = "22"
  }

  provisioner "file" {
    source = "../wazuh-ansible"
    destination = "/home/ubuntu/wazuh-ansible"
    connection {
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo DEBIAN_FRONTEND=noninteractive apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ansible",
      "sudo mkdir -p /home/ubuntu/.ssh",
      "sudo touch /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 644 /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 700 /home/ubuntu/.ssh",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "echo '${file(var.private_ssh_key)}' | sudo tee /home/ubuntu/.ssh/id_ed25519",
      "echo '${file(var.public_ssh_key)}' | sudo tee /home/ubuntu/.ssh/id_ed25519.pub",
      "sudo chmod 600 /home/ubuntu/.ssh/id_ed25519",
      "sudo chmod 644 /home/ubuntu/.ssh/id_ed25519.pub",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh/*",
      "sleep 60",
      "while fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do echo 'Apt is locked, waiting...'; sleep 5; done;",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ubuntu/wazuh-ansible/playbooks/inventory.ini /home/ubuntu/wazuh-ansible/playbooks/wazuh-production-ready.yml --private-key /home/ubuntu/.ssh/id_ed25519"
    ]
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
  tags  = "soc"
  agent = 0

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 2
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser   = "ubuntu"
  vmid     = 121 + count.index
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
  tags  = "soc"
  agent = 0

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 2
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser   = "ubuntu"
  vmid     = 124
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
  tags  = "soc"
  agent = 0

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 2
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser   = "ubuntu"
  vmid     = 125
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
  tags  = "soc"
  agent = 0

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 2
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser   = "ubuntu"
  vmid     = 126
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