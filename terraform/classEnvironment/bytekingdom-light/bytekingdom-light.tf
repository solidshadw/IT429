variable "vm_config" {
  type = map(object({
    name    = string
    desc    = string
    cores   = number
    memory  = number
    clone   = string
    dns     = string
    ip      = string
    gateway = string
  }))

  default = {
    "dc01" = {
      name    = "DC01"
      desc    = "DC01 - windows server 2019 - 192.168.0.10"
      cores   = 2
      memory  = 8192
      clone   = "WinServer2019x64-cloudinit-raw"
      dns     = "192.168.0.1"
      ip      = "192.168.0.10/24"
      gateway = "192.168.0.1"
    }
    "dc02" = {
      name    = "DC02"
      desc    = "DC02 - windows server 2019 - 192.168.0.11"
      cores   = 2
      memory  = 8192
      clone   = "WinServer2019x64-cloudinit-raw"
      dns     = "192.168.0.1"
      ip      = "192.168.0.11/24"
      gateway = "192.168.0.1"
    }
    "srv02" = {
      name    = "SRV02"
      desc    = "SRV02 - windows server 2019 - 192.168.0.22"
      cores   = 2
      memory  = 8192
      clone   = "WinServer2019x64-cloudinit-raw"
      dns     = "192.168.0.1"
      ip      = "192.168.0.22/24"
      gateway = "192.168.0.1"
    }
  }
}

resource "proxmox_virtual_environment_vm" "bytekingdom" {
  for_each = var.vm_config

  name        = each.value.name
  description = each.value.desc
  tags        = ["soc"]
  node_name   = var.pm_node
  pool_id     = var.pm_pool
  stop_on_destroy = true

  operating_system {
    type = "win10"
  }

  cpu {
    cores   = each.value.cores
    sockets = 2
  }

  memory {
    dedicated = each.value.memory
  }

  clone {
    vm_id   = lookup(var.vm_template_id, each.value.clone, -1)
    full    = var.pm_full_clone
    retries = 2
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  network_device {
    bridge = var.network_bridge
    model  = var.network_model
  }

  lifecycle {
    ignore_changes = [
      vga,
    ]
  }

  initialization {
    datastore_id = var.storage
    dns {
      servers = [
        each.value.dns
      ]
    }
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = each.value.gateway
      }
    }
  }
}