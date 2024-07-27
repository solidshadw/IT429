winrm_username        = "vagrant"
winrm_password        = "vagrant"
vm_name               = "Windows10x64-22h2-cloudinit-raw-uptodate"
template_description  = "Windows 10 - 22h2 - 64-bit - template built with Packer - {{isotime \"2006-01-02 03:04:05\"}}"
iso_file              = "local:iso/Windows-10-22h2_x64_en-us.iso"
autounattend_iso      = "./iso/Autounattend_windows10_cloudinit_uptodate.iso"
autounattend_checksum = "sha256:87f79a2e035988cd941d8056d9bfa81458142222a8e9065a3f2401e808afd85a"
vm_cpu_cores          = "2"
vm_memory             = "4096"
vm_disk_size          = "60G"
vm_sockets            = "1"
os                    = "win10"
vm_disk_format        = "raw"