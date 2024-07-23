packer {
  required_plugins {
    proxmox = {
      version = "1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

## Windows Setup ##

source "proxmox-iso" "windows" {
  additional_iso_files {
    device           = "sata3"
    iso_checksum     = var.autounattend_checksum
    iso_storage_pool = "local"
    iso_url          = var.autounattend_iso
    unmount          = true
  }

  additional_iso_files {
    device   = "sata4"
    iso_file = "local:iso/virtio-win-0.1.240.iso"
    unmount  = true
  }

  additional_iso_files {
    device   = "sata5"
    iso_file = "local:iso/scripts_withcloudinit.iso"
    unmount  = true
  }

  cloud_init              = true
  cloud_init_storage_pool = var.proxmox_iso_storage
  communicator            = "winrm"
  cores                   = var.vm_cpu_cores
  disks {
    disk_size    = var.vm_disk_size
    format       = var.vm_disk_format
    storage_pool = var.proxmox_vm_storage
    type         = "sata"
  }

  insecure_skip_tls_verify = var.proxmox_skip_tls_verify
  iso_file                 = var.iso_file
  memory                   = var.vm_memory
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  node                 = var.proxmox_node
  os                   = var.os
  token                = var.proxmox_token
  pool                 = var.proxmox_pool
  proxmox_url          = var.proxmox_url
  sockets              = var.vm_sockets
  template_description = var.template_description
  template_name        = var.vm_name
  username             = var.proxmox_username
  vm_name              = var.vm_name
  winrm_insecure       = true
  winrm_no_proxy       = true
  winrm_password       = var.winrm_password
  winrm_timeout        = "120m"
  winrm_use_ssl        = false
  winrm_username       = var.winrm_username
  task_timeout         = "40m"
}

## Ubuntu Setup ##

locals {
  packer_timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "proxmox-iso" "ubuntujammy" {
  bios                     = "${var.bios_type}"
  boot                     = "${var.boot}"
  boot_command             = ["${var.boot_command}"]
  boot_wait                = "${var.boot_wait}"
  cloud_init               = "${var.cloud_init}"
  cloud_init_storage_pool  = "${var.storage_pool}"
  communicator             = "ssh"
  cores                    = "${var.nb_core}"
  cpu_type                 = "${var.cpu_type}"
  http_directory           = "autoinstall"
  http_port_min            = "${var.http_port_min}"
  http_port_max            = "${var.http_port_max}"
  insecure_skip_tls_verify = true
  iso_file                 = "${var.iso_file}"
  machine                  = "${var.machine_default_type}"
  memory                   = "${var.nb_ram}"
  node                     = "${var.proxmox_node}"
  os                       = "${var.os_type}"
  token                 = "${var.proxmox_token}"
  proxmox_url              = "${var.proxmox_url}"
  pool                     = "${var.proxmox_pool}"
  qemu_agent               = "${var.qemu_agent_activation}"
  scsi_controller          = "${var.scsi_controller_type}"
  sockets                  = "${var.nb_cpu}"
  ssh_handshake_attempts   = "${var.ssh_handshake_attempts}"
  ssh_pty                  = true
  ssh_timeout              = "${var.ssh_timeout}"
  ssh_username             = "${var.ssh_username}"
  ssh_password             = "${var.ssh_password}"
  tags                     = "${var.tags}"
  template_description     = "${var.vm_info} - ${local.packer_timestamp}"
  unmount_iso              = true
  username                 = "${var.proxmox_username}"
  vm_id                    = "${var.vm_id}"
  vm_name                  = "${var.vm_name}"

  disks {
    discard      = "${var.disk_discard}"
    disk_size    = "${var.disk_size}"
    format       = "${var.disk_format}"
    io_thread    = "${var.io_thread}"
    storage_pool = "${var.storage_pool}"
    type         = "${var.disk_type}"
  }

  network_adapters {
    bridge   = "${var.bridge_name}"
    firewall = "${var.bridge_firewall}"
    model    = "${var.network_model}"
  }

  vga {
    type = "virtio"
  }
}

## Builds for Windows and Ubuntu ##

build {
  name    = "windows"
  sources = ["source.proxmox-iso.windows"]

  provisioner "powershell" {
    elevated_password = "vagrant"
    elevated_user     = "vagrant"
    scripts           = ["scripts/sysprep/cloudbase-init.ps1"]
  }

  provisioner "powershell" {
    elevated_password = "vagrant"
    elevated_user     = "vagrant"
    pause_before      = "1m0s"
    scripts           = ["scripts/sysprep/cloudbase-init-p2.ps1"]
  }
}

build {
  name = "ubuntu"
  sources = ["source.proxmox-iso.ubuntujammy"]

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox
  provisioner "shell" {
    execute_command = "echo 'packer' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    inline = [
      "echo 'Starting Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync",
      "echo 'Done Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'"
    ]
  }
}