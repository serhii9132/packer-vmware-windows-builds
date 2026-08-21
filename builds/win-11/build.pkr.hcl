locals {
    build_timestamp = formatdate("YYYY-MM-DD_hh-mm", timestamp())
    artifacts_output_directory = "artifacts/${var.vm_name}/${local.build_timestamp}"

    admin_password = textencodebase64("${var.winrm_password}AdministratorPassword", "UTF-16LE")
    logon_password = textencodebase64("${var.winrm_password}Password", "UTF-16LE")

    floppy_label = "cidata"
    
    floppy_content = {
      "/autounattend.xml" = templatefile("./${local.floppy_label}/autounattend.xml.pkrtpl.hcl", {
        admin_password = local.admin_password
        logon_password = local.logon_password
      })
    }

    floppy_files = [
      "./provision/scripts/pre-build/install-vmware-tools.ps1",
      "./provision/scripts/pre-build/configure-winrm.ps1"
    ]
}

variable "version" {
    type = number
}

variable "firmware" {
    type = string
}

variable "is_headless" {
    type = bool
}

variable "is_skip_export" {
    type = bool
}

variable "cpu_cores" {
    type = number
}

variable "memory" {
    type = number
}

variable "disk_size" {
    type = number
}

variable "disk_type_id" {
    type = number
}

variable "disk_adapter_type" {
    type = string
}

variable "network_adapter_type" {
    type = string
}

variable "communicator" {
    type = string
}

variable "cdrom_adapter_type" {
    type = string
}

variable "vm_name" {
  type = string
  default = "win-11"
}

variable "os_version" {
  type = string
  default = "windows11-64"
}

variable "iso_checksum" {
  type = string
  default = "none"
}

variable "iso_url" {
  type = string
  default = "./iso/win-11-eval-eng.iso"
}

variable "tools_mode" {
    type = string
}

variable "tools_source_path" {
    type = string
}

variable "boot_wait" {
    type = string
}

variable "boot_command" {
    type = list(string)
}

variable "shutdown_command" {
    type = string
}