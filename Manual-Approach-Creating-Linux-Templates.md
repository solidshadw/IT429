# Create Templates

We will need some templates on Proxmox. We will use the cloud images and then create templates from them.

> [!IMPORTANT]
> - Any username, password, ssh keys, and IPs that you set in the cloud init, will be used for future templates.
> - You will have to clean up your template if you decide to spin up the vm and add some tools, please refer to the clean up step.
> - Please follow step by step and READ carefully.

# Ubuntu Server

Default Creds
```sh
ubuntu:ubuntu
```

- Download this img of the ubuntu server into the proxmox server. Using this image as it is supported by the project I want to accomplish. 
```sh
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

- Install 7z on proxmox server  virt-customize to customize the img.  

```sh
sudo apt install p7zip-full libguestfs-tools
```

- We are just going to modify the image to include ansible and to allow ssh root login via an ssh key.

```bash
virt-customize -a jammy-server-cloudimg-amd64.img \
  --run-command 'mkdir -p /root/.ssh' \
  --run-command 'chmod 700 /root/.ssh' \
  --run-command 'sed -i "s/^#PermitRootLogin .*/PermitRootLogin prohibit-password/" /etc/ssh/sshd_config' \
  --run-command 'sed -i "s/^PasswordAuthentication .*/PasswordAuthentication no/" /etc/ssh/sshd_config' \
  --run-command 'sed -i "s/^#PubkeyAuthentication .*/PubkeyAuthentication yes/" /etc/ssh/sshd_config' \
  --run-command 'truncate -s 0 /etc/machine-id' \
  --run-command 'systemctl enable ssh'
```

- Create a virtual machine, so that we attach the ubuntu server cloud image: 
```sh
qm create 500 --memory 4096 --core 2 --name ubuntu-template --net0 virtio,bridge=vmbr0
```

- Import the disk to created vm and move image into local-lvm(or whatever storage in proxmox)
```sh
qm importdisk 500 jammy-server-cloudimg-amd64.img local-lvm
```

![screen1](/screenshots/Pasted_image_20240515145817.png)

- `qm set` to help setup and scsi and attach the ubuntu image that we just imported, make sure that whatever path you get from the output, that is your `scsi0`
```sh
qm set 500 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-500-disk-0
```

- We need to setup cloud init, this command will create a cdrom and attach it to the vm
```sh
qm set 500 --ide2 local-lvm:cloudinit
```

- Create bootdrive, so that we can boot from it:
```sh
qm set 500 --boot c --bootdisk scsi0
```

- Enable the QEMU Guest Agent for the VM.
```sh
qm set 500 --agent enabled=1
```

- Enable console, so that we can use in proxmox GUI
```sh
qm set 500 --vga std
```

Now we can go into the VM settings and into "Cloud-Init" and we can add some default creds like the ones I provided above or whatever you want. Remember this is only for the template. You can change creds later.

I didn't set anything else because I'll be setting the rest with proxmox.
![screen2](/screenshots/Pasted_image_20240519212908.png)


Now, this is the template for a ubuntu server I want, you can now right click and click "Convert to Template".

![screen3](/screenshots/Pasted_image_20240515151834.png)

# Kali

Default Creds
```
kali:kali
```

- Download the prebuilt vm from kalis website into the proxmox server. NOTE: if you want the more up to date, go to their site and download.
```sh
wget https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-vmware-amd64.7z
```

Install 7z on proxmox server  virt-customize to customize the img.  
```sh
sudo apt install p7zip-full libguestfs-tools
```

- Unzip the file with 7z
```sh
7z x kali-linux-2024.1-vmware-amd64.7z
```

Convert the image from VMDK format to RAW format.
```sh
qemu-img convert -f vmdk -O raw kali-linux-2024.1-vmware-amd64.vmwarevm/kali-linux-2024.1-vmware-amd64.vmdk kali-2024.1.img
```

Now we need to customize the image to make it configurable with cloud-init .

```sh
sudo virt-customize -a kali-2024.1.img --install cloud-init
```

Install qemu-guest-agent so that the guest can be controlled by the hypervisor.

```sh
sudo virt-customize -a kali-2024.1.img --install qemu-guest-agent
```

By default, the SSH service is disabled.  we will enable the SSH service.

```text
sudo virt-customize -a kali-2024.1.img --run-command 'systemctl enable ssh.service'
```

Finally, let's update the image with the latest packages. This might take some time....

```text
sudo virt-customize -a kali-2024.1.img --update
```

- Create a virtual machine, so that we attach the kali image: 
```sh
qm create 501 --memory 8192 --name kali-2024-1 --net0 virtio,bridge=vmbr0 
```

- Import the disk to created vm and move image into local-lvm(or whatever storage in proxmox)
```sh
qm importdisk 501 kali-2024.1.img local-lvm
```

![screen4](/screenshots/Pasted_image_20240515145817.png)

- `qm set` to help setup and scsi and attach the kali image that we just imported, make sure that whatever path you get from the output, that is your `scsi0`
```sh
qm set 501 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-501-disk-0 --sockets 2 --cores 4 --cpu x86-64-v2-AES
```

- We need to setup cloud init, this command will create a cdrom and attach it to the vm
```sh
qm set 501 --ide2 local-lvm:cloudinit
```

- Create bootdrive, so that we can boot from it:
```sh
qm set 501 --boot c --bootdisk scsi0
```

- Enable the QEMU Guest Agent for the VM.
```sh
qm set 501 --agent enabled=1
```

- Enable console, so that we can use in proxmox GUI
```sh
qm set 501 --vga std
```

Go into the GUI, click on the vm and right click and "Convert to template"

I also did give it 8GB of ram and more cores, you can switch this depending on how powerful is your server. Remember this is only a template, you can modify after you clone the vm.

## Cleaning up a VM 

This guide will help you clean up your VM and prepare it for further use. Follow the steps below to remove unnecessary files, set up a serial terminal, and configure cloud-init.

#### 1. Remove SSH Host Keys To remove existing SSH host keys, run the following command:
```sh
sudo rm /etc/ssh/ssh_host_*
```
#### 2. Truncate Machine ID

To clear the machine ID, use this command:
```sh
sudo truncate -s 0 /etc/machine-id
```
#### 3. Check for Symbolic Link of Machine ID

Make sure there is an symbolic link with the machine id by running this command, if you see the symbolic link you are good.
```sh
ls -l /var/lib/dbus/machine-id
```

If the symbolic link is not present, create it with the following command:

```sh
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
```
#### 4. Set Up Serial Terminal
Setup serial terminal, make sure this line looks like this

```sh
#/etc/default/grub
(...)
GRUB_CMDLINE_LINUX_DEFAULT="console=tty1 console=ttyS0"
(...)
```

Then update GRUB: 

```
sudo update-grub
```
#### 5. Install Cloud-Init
```
sudo apt install cloud-init
```
#### 6. Configure Cloud-Init
Configure cloud-init to use the appropriate data sources:
```
echo "datasource_list: [ NoCloud, ConfigDrive ]" | sudo tee /etc/cloud/cloud.cfg.d/99_pve.cfg
```
#### 7. Clean Cloud-Init

```
sudo cloud-init clean
```



