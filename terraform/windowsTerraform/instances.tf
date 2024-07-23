# "Telmate/proxmox" "3.0.1-rc1" template (change clone value to template name to use it and change the provider in main)
resource "proxmox_vm_qemu" "windows-server-2019" {
  count       = 1
  name        = "windows-server-2019-VM-${count.index}"
  target_node = var.target_node
  onboot      = true
  qemu_os     = "win10"
  cores       = 2
  sockets     = 2
  memory      = 12500
  agent       = 1
  clone       = var.template_name_windowsserver2019
  full_clone  = true
  os_type     = "cloud-init"
  boot        = "order=sata0;ide2"
  scsihw      = "virtio-scsi-single"

  # disk type need to match with disk type in template, in this case sata0
  bootdisk = "sata0"
  # Specify the cloud-init cdrom storage
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    sata {
      sata0 {
        disk {
          size    = "50G"
          storage = "local-lvm"
        }
      }
    }
  }
  network {
    bridge = "vmbr0"
    model  = "e1000"
  }

  nameserver = "192.168.0.1" #DNS server
  ipconfig0  = "ip=192.168.0.140/24,gw=192.168.0.1"

  provisioner "remote-exec" {
    inline = ["echo 'wait for winrm connection'"]
    connection {    
      type     = "winrm"    
      user     = "vagrant"    
      password = "vagrant"    
      host     = "192.168.0.145"
      port=5986
      insecure = true
      https = true
    }
  }

  provisioner "local-exec" {
   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts  -l '192.168.0.145' ./ansible/windows_test.yml -e ansible_user=vagrant -e ansible_password=vagrant -e ansible_connection=winrm -e ansible_winrm_server_cert_validation=ignore -e ansible_port=5986 -e 'target_host=192.168.0.145'"
  }
}

# "Telmate/proxmox" "3.0.1-rc1" template (change clone value to template name to use it and change the provider in main)
resource "proxmox_vm_qemu" "windows-server-2016" {
  count       = 1
  name        = "windows-server-2016-VM-${count.index}"
  target_node = var.target_node
  onboot      = true
  qemu_os     = "win10"
  cores       = 2
  sockets     = 2
  memory      = 12500
  agent       = 1
  clone       = var.template_name_windowsserver2016
  full_clone  = true
  os_type     = "cloud-init"
  boot        = "order=sata0;ide2"
  scsihw      = "virtio-scsi-single"

  # disk type need to match with disk type in template, in this case sata0
  bootdisk = "sata0"
  # Specify the cloud-init cdrom storage
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    sata {
      sata0 {
        disk {
          size    = "50G"
          storage = "local-lvm"
        }
      }
    }
  }
  network {
    bridge = "vmbr0"
    model  = "e1000"
  }

  nameserver = "192.168.0.1" #DNS server
  ipconfig0  = "ip=192.168.0.141,gw=192.168.0.1"

  provisioner "remote-exec" {
    inline = ["echo 'wait for winrm connection'"]
    connection {    
      type     = "winrm"    
      user     = "vagrant"    
      password = "vagrant"    
      host     = "192.168.0.145"
      port=5986
      insecure = true
      https = true
    }
  }

  provisioner "local-exec" {
   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts  -l '192.168.0.145' ./ansible/windows_test.yml -e ansible_user=vagrant -e ansible_password=vagrant -e ansible_connection=winrm -e ansible_winrm_server_cert_validation=ignore -e ansible_port=5986 -e 'target_host=192.168.0.145'"
  }
}

# "Telmate/proxmox" "3.0.1-rc1" template (change clone value to template name to use it and change the provider in main)
resource "proxmox_vm_qemu" "windows-10" {
  count       = 1
  name        = "windows10-VM-${count.index}"
  target_node = var.target_node
  onboot      = true
  qemu_os     = "win10"
  cores       = 2
  sockets     = 2
  memory      = 12500
  agent       = 1
  clone       = var.template_name_windows10
  full_clone  = true
  os_type     = "cloud-init"
  boot        = "order=sata0;ide2"
  scsihw      = "virtio-scsi-single"

  # disk type need to match with disk type in template, in this case sata0
  bootdisk = "sata0"
  # Specify the cloud-init cdrom storage
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    sata {
      sata0 {
        disk {
          size    = "50G"
          storage = "local-lvm"
        }
      }
    }
  }
  network {
    bridge = "vmbr0"
    model  = "e1000"
  }

  nameserver = "192.168.0.1" #DNS server
  ipconfig0  = "ip=192.168.0.142/24,gw=192.168.0.1"

  provisioner "remote-exec" {
    inline = ["echo 'wait for winrm connection'"]
    connection {    
      type     = "winrm"    
      user     = "vagrant"    
      password = "vagrant"    
      host     = "192.168.0.145"
      port=5986
      insecure = true
      https = true
    }
  }

  provisioner "local-exec" {
   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts  -l '192.168.0.145' ./ansible/windows_test.yml -e ansible_user=vagrant -e ansible_password=vagrant -e ansible_connection=winrm -e ansible_winrm_server_cert_validation=ignore -e ansible_port=5986 -e 'target_host=192.168.0.145'"
  }
}