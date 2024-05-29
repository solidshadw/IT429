# Installing Ubuntu Server VM

## Prerequisites

1. **Ubuntu Server ISO**: Download the latest Ubuntu Server ISO from the [official website](https://ubuntu.com/download/server).
2. **VMware Workstation** or **VirtualBox**: Ensure you have either VMware Workstation or VirtualBox installed on your machine.

## Part 1: VMware Workstation

### Step 1: Create a New Virtual Machine

1. Open **VMware Workstation**.
2. Click on `File` > `New Virtual Machine...`.
3. Select `Typical (recommended)` and click `Next`.

### Step 2: Select the Installation Media

1. Select `Installer disc image file (iso):`.
2. Browse and select the downloaded Ubuntu Server ISO file.
3. Click `Next`.

### Step 3: Configure Virtual Machine

1. Enter the `Virtual Machine Name` (e.g., UbuntuServer).
2. Choose the location to store the VM files.
3. Click `Next`.

### Step 4: Specify Disk Capacity

1. Specify the disk size (e.g., 20 GB).
2. Select `Store virtual disk as a single file`.
3. Click `Next`.

### Step 5: Customize Hardware (Optional)

1. Click on `Customize Hardware...` to adjust settings like CPU, Memory, Network Adapter, etc.
2. Click `Close` when done.
3. Click `Finish` to create the VM.

### Step 6: Install Ubuntu Server

1. Power on the virtual machine.
2. Follow the on-screen instructions to install Ubuntu Server.
   - Choose the language.
   - Select `Install Ubuntu Server`.
   - Follow the prompts to set up your network, storage, user account, and SSH setup if needed.
3. Once the installation is complete, restart the VM.

## Part 2: VirtualBox

### Step 1: Create a New Virtual Machine

1. Open **VirtualBox**.
2. Click on `New`.
3. Enter the `Name` (e.g., UbuntuServer).
4. Choose the `Type` as `Linux` and `Version` as `Ubuntu (64-bit)`.
5. Click `Next`.

### Step 2: Allocate Memory

1. Allocate the desired amount of memory (e.g., 2048 MB).
2. Click `Next`.

### Step 3: Create a Virtual Hard Disk

1. Select `Create a virtual hard disk now`.
2. Click `Create`.

### Step 4: Hard Disk File Type

1. Choose `VDI (VirtualBox Disk Image)`.
2. Click `Next`.

### Step 5: Storage on Physical Hard Disk

1. Choose `Dynamically allocated`.
2. Click `Next`.

### Step 6: Specify Disk Size

1. Set the size of the virtual hard disk (e.g., 20 GB).
2. Click `Create`.

### Step 7: Configure VM Settings

1. Select the new VM and click on `Settings`.
2. Go to `System` > `Processor` tab and allocate the desired number of processors.
3. Go to `Storage` > `Controller: IDE`.
   - Click on the `Empty` disk.
   - Click on the disk icon next to `Optical Drive`.
   - Choose `Choose a disk file...` and select the downloaded Ubuntu Server ISO.

### Step 8: Network Settings

1. Go to `Network`.
2. Ensure `Attached to:` is set to `NAT` or `Bridged Adapter` as per your requirements.
3. Click `OK` to save the settings.

### Step 9: Install Ubuntu Server

1. Select the VM and click `Start`.
2. Follow the on-screen instructions to install Ubuntu Server.
   - Choose the language.
   - Select `Install Ubuntu Server`.
   - Follow the prompts to set up your network, storage, user account, and SSH setup if needed.
3. Once the installation is complete, restart the VM.

## Conclusion

You have successfully installed Ubuntu Server on a virtual machine using both VMware Workstation and VirtualBox. You can now proceed to configure your server as needed.

Feel free to modify the steps based on your specific requirements and preferences.
