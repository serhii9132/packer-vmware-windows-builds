## packer-windows-vmware-builds

This repository contains configuration files for a fully unattended installation of the following operating systems:
- Windows Server 2022 Standart (Desktop) Evaluation
- Windows Server 2025 Standart (Desktop) Evaluation
- Windows 11 Evaluation

### Template details:
- CPU: 4 cores
- Disk: 100 Gb
- Type disk: growable virtual disk contained in a single file
- RAM: 6 Gb
- Firmware: EFI
- Network adapter type: vmxnet3

### Note
It is assumed that the Windows Evaluation ISO images are already downloaded locally and are located in the “iso” directory in the project root.

### Usage
1. Create a .env file in the project root directory with the following content:
 ```sh
 PKR_VAR_winrm_password=
 ```
2. Run the following commands:
```sh
make server-22
make server-25
make win-11
```
After execution, the VMware virtual machine files will appear in artifacts/${var.vm_name}/${current_timestamp}.