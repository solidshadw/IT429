
# Class Environment Setup

> [!NOTE]
> **Credit to the following repos and authors, as I used some of their code to compile into this environment. Please check them out:**
> - https://github.com/Orange-Cyberdefense/GOADndows_VirtIO_Drivers
> - https://github.com/iknowjason/AutomatedEmulation
> - https://github.com/wazuh/wazuh-ansible

> [!Important]
> ** This has only being tested on Linux and will only work for Proxmox as the virtualization software**

> [!Caution]
> **This is a vulnerable environment, please don't use in production, this is for educational purposes**

## Requirements

- Run `provisioner.sh` that will check for the required tools and tell you if you have them or not.
```bash
./provisioner.sh -t check -l bytekingdom-light
```

- Create an Proxmox API User that terraform will use to authenticate and create the environment. Follow this [steps](https://github.com/solidshadw/IT429/blob/main/Setup-Terraform-User.md) for creation of that user on your proxmox terminal.
- Ubuntu Template, follow this [steps](https://github.com/solidshadw/IT429/blob/main/Manual-Approach-Creating-Linux-Templates.md)
- Windows 2019 Template, follow this [steps](https://github.com/solidshadw/IT429/tree/main/packer/proxmox)


## Step 1 - Clone the Repo

Clone the repository to your local machine:
```bash
git clone https://github.com/solidshadw/IT429.git
```

We will be working on the `terraform/classEnvironment` folder

```
cd terraform/classEnvironment
```

## Step 2 -  Setup Variables

You will need to update the variables for terraform to be able to run, you will update this variables in 2 spots:
1. `terraform/classEnvironment/bytekingdom-light/terraform.tfvars.template`
2. `terraform/classEnvironment/SIEM/terraform.tfvars.template`

> [!Important]
> ** All variables need to be filled out, if not your terraform might error out.**

## Step 2 -  Setup Networking

In this case, the networking is hardcoded in files, I'm hoping I can make this easier in a later release, but for now. This is where the networking for the VMs will be at. 

**BYTEKINGDOM Environment**

- `terraform/classEnvironment/bytekingdom-light/instances.tf` - This is for the IP's of the VM's
- `terraform/classEnvironment/bytekingdom-light/inventory` - This file is the one that ansible uses to setup the vulnerable environment
- `terraform/classEnvironment/bytekingdom-light/ansible/wazuh-agent.yml` - We need to setup the **wazuh_manager** IP address, for the agents to install on the vulnerable environment.

**SIEM**
- `terraform/classEnvironment/SIEM/instances.tf` - Make changes under `ipconfig0` for each one of the VMs.
- `terraform/wazy-ansible/playbooks/inventory.ini` - This will setup the IPs for the VMs for ansible to install the Wazuh SIEM.
- `terraform/wazy-ansible/playbooks/wazuh-agent.yml` - Setup the **wazuh_manager** IP address, for the agents to install.

## Step 3 -  Setup the Environment

Run the `provisioner.sh`. This will run the terraform to create both environments. 
```bash
./provisioner.sh -t install -l bytekingdom-light,SIEM
```

If it fails, you can run the `destroy` and then run the install again....

### Optional

If you only want to create one Lab/Environment: 
```bash
./provisioner.sh -t install -l SIEM
```

If you only want to run an ansible playbook for the bytekingdom-light environment. Note, that this will only work for the bytekingdom-light environment : 
```bash
./provisioner.sh -t install -l bytekingdom-light -r wazuh-agent.yml
```


## Notes

You can also destroy the environment with:
```
./provisioner.sh -t destroy -l bytekingdom-light,SIEM
```
You will need to be in the same host/terminal that the `install` was ran from. Because terraform uses `.tfstate` files to keep track of resources created.
If you don't have access to that host, you will have to manually stop and remove the VM's from proxmox.

![classEnv](https://github.com/user-attachments/assets/f777c992-744e-4bac-8b45-ab63c5dbdfad)

