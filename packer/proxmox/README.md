# Promox VM packer

I have taken much of the configuration for creating a template from [GOAD](https://github.com/Orange-Cyberdefense/GOAD/tree/main) and I have adapted it to what I needed. So, the credit to them in some of this work.

## Step#1 - Download Windows isos

To avoid having to download the iso everytime, we will just download, upload it and reference it, everytime that we create a template.

Windows iso evaluation to download and put inside the iso storage of proxmox. In this script, it is being saved in "local".

- [Windows-10-22h2_x64_en-us.iso](https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso)
- [windows_server_2016_14393.0_eval_x64.iso](https://software-download.microsoft.com/download/pr/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO)
- [windows_server2019_x64FREE_en-us.iso](https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso)

> [!IMPORTANT]
> Be sure to name the iso like the name inside
   
## Step#2 - Cloudbase init 

- Download here : https://cloudbase.it/cloudbase-init/
- Put the msi at : /packer/proxmox/scripts/sysprep/CloudbaseInitSetup_1_1_5_x64 .msi (54,7M)
> [!IMPORTANT]
> When you download the MSI, make sure it matches the name on this file: "`packer\proxmox\scripts\sysprep\cloudbase-init.ps1`"


## (Optional) Windows update
- If you want to create updated templates make sure that you select the pkvars.hcl that contains the `uptodate` name.
- This will take a long time, you have been warned.

## Step#3 - Prepare

This script automates the creation of several ISO images containing the necessary files for unattended Windows and Windows Server installations with cloud-init on Proxmox. It also updates the corresponding HCL files with the new SHA-256 checksums of the created ISOs, ensuring that the configurations point to the correct files.

```bash
sudo apt-get install mkisofs
cd /root/GOAD/packer/proxmox/
./build_proxmox_iso.sh
```
- Put the packer/proxmox/iso/scripts_withcloudinit.iso into proxmox's iso folder

## Step#3 - Configure

```bash
cp config.auto.pkrvars.hcl.template config.auto.pkrvars.hcl
```
- And adapt the value to your proxmox config

## Install Packer

https://developer.hashicorp.com/packer/install


## BUILD

```
packer validate -var-file=windows_server2016_proxmox_cloudinit.pkvars.hcl -only="windows.*" .
packer build -var-file=windows_server2016_proxmox_cloudinit.pkvars.hcl -only="windows.*" .
```