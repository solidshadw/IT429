We will need some templates on Proxmox. We will use the cloud images and then create templates.

#### KEEP IN MIND:
- Don't start the vm when you are creating templates
- Any username, password, ssh keys, and IPs that you set in the cloud init, will be used for future templates.

## Ubuntu Server

Default Creds
```
ubuntu:changeme123!
```

- Download this img of the ubuntu server into the proxmox server.
```
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

- Create a virtual machine, so that we attach the ubuntu server cloud image: 
```
qm create 500 --memory 4096 --name ubuntu-cloud --net0 virtio,bridge=vmbr0 
```

- Import the disk to created vm and move image into local-lvm(or whatever storage in proxmox)
```
qm importdisk 500 noble-server-cloudimg-amd64.img local-lvm
```

![[screenshots/Pasted image 20240515145817.png]]

- `qm set` to help setup and scsi and attach the ubuntu image that we just imported, make sure that whatever path you get from the output, that is your `scsi0`
```
qm set 500 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-500-disk-0
```

- We need to setup cloud init, this command will create a cdrom and attach it to the vm
```
qm set 500 --ide2 local-lvm:cloudinit
```

- Create bootdrive, so that we can boot from it:
```
qm set 500 --boot c --bootdisk scsi0
```

- Enable console, so that we can use in proxmox GUI
```
qm set 500 --serial0 socket --vga serial0
```

Now we can go into the VM settings and into "Cloud-Init" and we can add some default creds like the ones I provided above or whatever you want. Remember this is only the template. You can change creds later.

Also, setup DHCP for your VM or an static IP. Since this is a template, set it to DHCP.
![[screenshots/Pasted image 20240515151308.png]]

> 🚨 **DO NOT START THE VM! We want the ubuntu vanilla**

Make sure the hardware looks like this or you can configure anything you want: 

![[screenshots/Pasted image 20240515151641.png]]

Now, this is the vanilla image we want, you can now right click and click "Convert to Template"

![[screenshots/Pasted image 20240515151834.png]]

## Kali

Default Creds
```
kali:kali
```

- Download the prebuilt vm from kalis website into the proxmox server. NOTE: if you want the more up to date, go to their site and download.
```
wget https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-qemu-amd64.7z
```

Install 7z on proxmox server: 
```
apt install p7zip-full
```

- Unzip the file with 7z
```
7z x kali-linux-2024.1-qemu-amd64.7z
```

- Create a virtual machine, so that we attach the kali image: 
```
qm create 501 --memory 8192 --name kali-prebuilt-vm-2024-1 --net0 virtio,bridge=vmbr0 
```

- Import the disk to created vm and move image into local-lvm(or whatever storage in proxmox)
```
qm importdisk 501 kali-linux-2024.1-qemu-amd64.qcow2 local-lvm
```

![[screenshots/Pasted image 20240515145817.png]]

- `qm set` to help setup and scsi and attach the kali image that we just imported, make sure that whatever path you get from the output, that is your `scsi0`
```
qm set 501 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-501-disk-0 --sockets 2 --cores 4 --cpu x86-64-v2-AES
```

- We need to setup cloud init, this command will create a cdrom and attach it to the vm
```
qm set 501 --ide2 local-lvm:cloudinit
```

- Create bootdrive, so that we can boot from it:
```
qm set 501 --boot c --bootdisk scsi0
```

- Enable console, so that we can use in proxmox GUI
```
qm set 501 --vga std
```

Go into the GUI, click on the vm and then "Cloud-Init", you will then select "IP Config" and make it dhcp
![[screenshots/Pasted image 20240515160305.png]]

I also did give it 8GB of ram and more cores, you can switch this depending on how powerful is your server. Remember this is only a template, you can modify when you create a vm.

## Windows 11
```
https://cloud-images.ubuntu.com/
```
## Windows Server
```
https://cloud-images.ubuntu.com/
```

## Centos9Stream

Default Creds
```
luigi:changeme123!
```

- Download this img of the centos9 server into the proxmox server.
```
wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-x86_64-9-latest.x86_64.qcow2
```

- Create a virtual machine, so that we attach the ubuntu server cloud image: 
```
qm create 503 --memory 24576 --name centos9stream-cloud --net0 virtio,bridge=vmbr0
```

- Import the disk to created vm and move image into local-lvm(or whatever storage in proxmox)
```
qm importdisk 503 CentOS-Stream-GenericCloud-x86_64-9-latest.x86_64.qcow2 local-lvm
```

![[screenshots/Pasted image 20240515222104.png]]

- `qm set` to help setup and scsi and attach the ubuntu image that we just imported, make sure that whatever path you get from the output, that is your `scsi0`
```
qm set 503 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-503-disk-0  --sockets 2 --cores 4 --cpu x86-64-v2-AES
```

- We need to setup cloud init, this command will create a cdrom and attach it to the vm
```
qm set 503 --ide2 local-lvm:cloudinit
```

- Create bootdrive, so that we can boot from it:
```
qm set 503 --boot c --bootdisk scsi0
```

- Enable console, so that we can use in proxmox GUI
```
qm set 503 --serial0 socket --vga serial0
```

Now we can go into the VM settings and into "Cloud-Init" and we can add some default creds like the ones I provided above or whatever you want. Remember this is only the template. You can change creds later.

Also, setup DHCP for your VM or an static IP. Since this is a template, set it to DHCP.


> 🚨 **DO NOT START THE VM! We want the ubuntu vanilla**

Make sure the hardware looks like this or you can configure anything you want: 



Now, this is the vanilla image we want, you can now right click and click "Convert to Template"
