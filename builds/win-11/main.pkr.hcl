packer {
  required_plugins {
    vmware = {
      version = "2.1.1"
      source  = "github.com/vmware/vmware"
    }
    windows-update = {
      version = "0.18.1"
      source  = "github.com/rgl/windows-update"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "1.1.7"
    }
  }
}

source "vmware-iso" "windows" {
  version                = var.version
  firmware               = var.firmware
  headless               = var.is_headless
  skip_export            = var.is_skip_export
   
  cpus                   = var.cpu_cores
  cores                  = var.cpu_cores
  memory                 = var.memory
  disk_size              = var.disk_size
  disk_type_id           = var.disk_type_id
  disk_adapter_type      = var.disk_adapter_type
  network_adapter_type   = var.network_adapter_type
  communicator           = var.communicator
  cdrom_adapter_type     = var.cdrom_adapter_type
  vm_name                = var.vm_name
  guest_os_type          = var.os_version

  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  output_directory       = abspath("${local.artifacts_output_directory}")

  floppy_label           = local.floppy_label
  floppy_content         = local.floppy_content
  floppy_files           = local.floppy_files

  tools_mode             = var.tools_mode
  tools_source_path      = var.tools_source_path

  vnc_bind_address       = var.vnc_bind_address
  vnc_port_min           = var.vnc_port_min
  vnc_port_max           = var.vnc_port_max
  vnc_disable_password   = var.is_vnc_disable_password

  winrm_username         = var.winrm_username
  winrm_password         = var.winrm_password
  winrm_port             = var.winrm_port
  winrm_use_ssl          = var.is_winrm_use_ssl
  winrm_insecure         = var.is_winrm_insecure
  winrm_timeout          = var.winrm_timeout

  boot_wait              = var.boot_wait
  boot_command           = var.boot_command
  shutdown_command       = var.shutdown_command
}

build {
  sources = ["source.vmware-iso.windows"]

  provisioner "windows-restart" {}

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Driver*'",
      "exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
    update_limit = 10
  }

  provisioner "file" {
    content = templatefile("${path.cwd}/provision/configs/sysprep/desktop/unattend.xml.pkrtpl.hcl", {
      admin_password = local.admin_password
      logon_password = local.logon_password
    })
    destination = "C:/Windows/Panther/unattend.xml"
  }

  provisioner "powershell" {
    inline = [
      "New-Item -ItemType Directory -Force -Path 'C:/Windows/Setup/Scripts'"
    ]
  }

  provisioner "file" {
    source  = "${path.cwd}/provision/scripts/sysprep/init-winrm.ps1"
    destination = "C:/Windows/Setup/Scripts/init-communicator.ps1"
  }

  provisioner "file" {
    source = "${path.cwd}/provision/scripts/sysprep/SetupComplete.cmd"
    destination = "C:/Windows/Setup/Scripts/SetupComplete.cmd"
  }

  provisioner "powershell" {
    inline = [
      "Write-Host 'Setting WinRM to Manual startup'",
      "Set-Service -Name WinRM -StartupType Manual"
    ]
  }

  provisioner "powershell" {
    script     = "${path.cwd}/provision/scripts/post-build/cleanup.ps1"
    skip_clean = true
  }

  post-processor "vagrant" {
    keep_input_artifact  = true
    output               = "${local.artifacts_output_directory}/${var.vm_name}.box"
  }
}