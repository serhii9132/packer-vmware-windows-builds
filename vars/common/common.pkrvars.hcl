version = 22
firmware = "efi"
is_headless = true
is_skip_export = true

cpu_cores = 4
memory = 6144
disk_size = 100000
disk_type_id = 0
disk_adapter_type = "nvme"
network_adapter_type = "vmxnet3"
communicator = "winrm"
cdrom_adapter_type = "sata"

tools_mode = "attach"
tools_source_path = "C:/Program Files (x86)/VMware/VMware Workstation/windows.iso"

iso_checksum = "none"
iso_url = "./iso"

vnc_bind_address = "127.0.0.1"
vnc_port_min = 5960
vnc_port_max = 5970
is_vnc_disable_password = true

winrm_username = "Administrator"
winrm_port = 5986
is_winrm_use_ssl = true
is_winrm_insecure = true
winrm_timeout = "2h"

boot_wait = "2s"
boot_command = [ "<enter><enter><enter><enter><enter><enter><enter><enter><enter><enter><enter>" ]
shutdown_command = "C:/Windows/system32/Sysprep/sysprep.exe /generalize /oobe /shutdown /quiet /mode:vm"