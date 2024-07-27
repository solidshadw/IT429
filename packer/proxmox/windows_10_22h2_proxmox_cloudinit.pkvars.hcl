winrm_username        = "vagrant"
winrm_password        = "vagrant"
vm_name               = "Windows10x64-22h2-cloudinit-raw"
template_description  = "Windows 10 - 22h2 - 64-bit - template built with Packer - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file              = "local:iso/Windows-10-22h2_x64_en-us.iso"
autounattend_iso      = "./iso/Autounattend_windows10_cloudinit.iso"
autounattend_checksum = "sha256:3fc95a628304e61573df3af8dc83407f123991fcd8bf56dccbd3bc678a28117d"
vm_cpu_cores          = "2"
vm_memory             = "4096"
vm_disk_size          = "60G"
vm_sockets            = "1"
os                    = "win10"
vm_disk_format        = "raw"