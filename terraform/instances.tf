resource "proxmox_vm_qemu" "ubuntu_cloud_vm" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = var.template_id_ubuntu
  count       = 2

  # Activate QEMU agent for this VM
  agent = 0

  os_type  = "cloud-init"
  pool     = "SOC-Class"
  cores    = 2
  sockets  = 1
  memory   = 2048
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  disk {
    size    = "10G"
    type    = "virtio"
    storage = "local-lvm"
  }

  vga {
    type = "std"
    #Between 4 and 512, ignored if type is defined to serial
    memory = 4
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=dhcp"
}

output "vm_id" {
  description = "The ID of the created VM"
  value       = proxmox_vm_qemu.ubuntu_cloud_vm.*.id
}