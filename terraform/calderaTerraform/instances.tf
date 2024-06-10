################ Ansible Server ######################################
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

  provisioner "remote-exec" {
    inline = [
      "while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do echo 'Waiting for lock...'; sleep 5; done",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install git python3 python3-pip docker docker-compose",
      "git clone https://github.com/mitre/caldera.git --recursive",
      "cd caldera",
      ## Change the host IP in the default.yml file. Current bug on caldera
      "sed -i 's/^host: .*/host: 192.168.0.130/' conf/default.yml",
      "sudo docker-compose build",
      "sudo docker run -d -p 7010:7010 -p 7011:7011/udp -p 7012:7012 -p 8888:8888 caldera:latest"
    ]
  }
}