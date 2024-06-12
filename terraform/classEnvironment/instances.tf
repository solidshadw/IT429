
################ Caldera Server ######################################

resource "proxmox_vm_qemu" "ubuntu_vm_caldera_server" {
  count       = 1
  name        = "ubuntu-caldera-offensive-server"
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
  vmid     = 130


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
          size    = "120G"
        }
      }
    }
  }

  ipconfig0 = "ip=192.168.0.130/24,gw=192.168.0.1"

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
    source      = "./setupFiles"
    destination = "/home/ubuntu/setupFiles"
    connection {
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/setupFiles",
      "chmod +x bootstrap.sh",
      "sudo ./bootstrap.sh"
    ]
  }
}

################ Ansible Server ######################################
resource "proxmox_vm_qemu" "ubuntu_vm_ansible_server" {
  depends_on = [proxmox_vm_qemu.ubuntu_vm_caldera_server, proxmox_vm_qemu.ubuntu_vm_indexers, proxmox_vm_qemu.ubuntu_vm_node1, proxmox_vm_qemu.ubuntu_vm_node2, proxmox_vm_qemu.ubuntu_vm_dashboard]

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
    source      = "../wazy-ansible"
    destination = "/home/ubuntu/wazy-ansible"
    connection {
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "while fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do sleep 5; done;",
      "RETRIES=5; COUNT=0; until sudo DEBIAN_FRONTEND=noninteractive apt-get update; do COUNT=$(($COUNT + 1)); if [ $COUNT -ge $RETRIES ]; then exit 1; fi; sleep 10; done",
      "sudo mkdir -p /home/ubuntu/.ssh",
      "sudo touch /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 644 /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 700 /home/ubuntu/.ssh",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "echo '${file(var.private_ssh_key)}' | sudo tee /home/ubuntu/.ssh/ansibleKeys",
      "echo '${file(var.public_ssh_key)}' | sudo tee /home/ubuntu/.ssh/ansibleKeys.pub",
      "sudo chmod 600 /home/ubuntu/.ssh/ansibleKeys",
      "sudo chmod 644 /home/ubuntu/.ssh/ansibleKeys.pub",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh/*",
      "sleep 30",
      "while fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/cache/apt/archives/lock >/dev/null 2>&1; do sleep 5; done;",
      "RETRIES=8; COUNT=0; until sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install ansible; do COUNT=$(($COUNT + 1)); if [ $COUNT -ge $RETRIES ]; then exit 1; fi; sleep 20; done",
      # Adding some retries in case it fails
      "RETRIES=3; COUNT=0; until ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ubuntu/wazy-ansible/playbooks/inventory.ini /home/ubuntu/wazy-ansible/playbooks/wazuh-production-ready.yml --private-key /home/ubuntu/.ssh/ansibleKeys; do COUNT=$(($COUNT + 1)); if [ $COUNT -ge $RETRIES ]; then exit 1; fi; sleep 10; done",
      "RETRIES=3; COUNT=0; until ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ubuntu/wazy-ansible/playbooks/inventory.ini /home/ubuntu/wazy-ansible/playbooks/wazuh-agent.yml -b --private-key /home/ubuntu/.ssh/ansibleKeys; do COUNT=$(($COUNT + 1)); if [ $COUNT -ge $RETRIES ]; then exit 1; fi; sleep 10; done"
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