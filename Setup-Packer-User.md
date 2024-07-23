# Setup Packer User for Proxmox API

We will be setting up a Packer User to allows to use Proxmox API and create templates for our VMs.

```bash
pveum useradd packer@pve
```

```bash
pveum passwd packer@pve
```
## Role Packer Creation
```bash
pveum roleadd Packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateTemplate Datastore.Audit Datastore.AllocateSpace Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Cloudinit VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor SDN.Use Datastore.Allocate"
```
## Role attribution
```bash
pveum acl modify / -user 'packer@pve' -role Packer
```

```bash
pveum user token add packer@pve packer_token
```

```bash
pveum aclmod / -token 'packer@pve!packer_token' -role Packer
```

```bash
pveum aclmod /sdn/zones/localnetwork/vmbr0 -user packer@pve -role Packer
```

```bash
pveum aclmod /sdn/zones/localnetwork/vmbr0 -token 'packer@pve!packer_token' -role Packer
```

## Setup Token to have access to storage

```bash
pvesh set /access/acl -path /storage/ISOs -roles Packer -token 'packer@pve!packer_token'
```

```bash
pvesh set /access/acl -path /storage/local-lvm -roles Packer -token 'packer@pve!packer_token'
```

# Setup your System

```bash
sudo apt-get update
```

```bash
sudo apt-get install xorriso
```





