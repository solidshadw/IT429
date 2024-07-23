# Setup Terraform User for Proxmox API

Creating a dedicated Terraform user with specific privileges in Proxmox VE ensures secure and efficient management of your virtual environment. This guide outlines the steps to set up a Terraform user, assign necessary roles, and create an API token for seamless integration with Terraform.

## Step-by-Step Guide

### Create the role with specified privileges
```
pveum role add terraform_role -privs "Datastore.AllocateSpace,Datastore.Audit,Pool.Allocate,Sys.Audit,Sys.Console,Sys.Modify,VM.Allocate,VM.Audit,VM.Clone,VM.Config.CDROM,VM.Config.Cloudinit,VM.Config.CPU,VM.Config.Disk,VM.Config.HWType,VM.Config.Memory,VM.Config.Network,VM.Config.Options,VM.Migrate,VM.Monitor,VM.PowerMgmt,SDN.Use"
```
### Add the user
Next, add the Terraform user to Proxmox VE, keep in mind this doesn't add a user in the linux system.

```
pveum user add terraform@pve
```

And now we set the password, I don't like setting passwords as a command line argument...

```
pveum passwd terraform@pve
```
### Assign the role to the user
Assign the previously created role to the Terraform user:
```
pveum aclmod / -user terraform@pve -role terraform_role
```

### Create an API token for the user

Make sure that you save the `full-tokenid` and the `value` from that output. As we will insert them in our `terraform.tfvars` file.

```
pveum user token add terraform@pve terraform_token
```

![screen1](/screenshots/Pasted_image_20240517143622.png)

Add them to our `terraform.tfvars` file:

![screen2](/screenshots/Pasted_image_20240517143752.png)

### Assign the role to the API token
Ensure the API token has the same privileges as the Terraform user:

```
pveum aclmod / -token 'terraform@pve!terraform_token' -role terraform_role
```

### Assign the role to the SDN resource

These commands assign the terraform_role to both the user and the API token for the specific SDN resource path /sdn/zones/localnetwork/vmbr0. This ensures that the user and the API token have the necessary SDN.Use privilege to interact with the SDN resource.

```
pveum aclmod /sdn/zones/localnetwork/vmbr0 -user terraform@pve -role terraform_role
```

```
pveum aclmod /sdn/zones/localnetwork/vmbr0 -token 'terraform@pve!terraform_token' -role terraform_role
```