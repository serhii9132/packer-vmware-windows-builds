locals {
    build_timestamp = formatdate("YYYY-MM-DD_hh-mm", timestamp())
    artifacts_output_directory = "${path.cwd}/artifacts/${var.vm_name}/${local.build_timestamp}"

    admin_password = textencodebase64("${var.winrm_password}AdministratorPassword", "UTF-16LE")
    logon_password = textencodebase64("${var.winrm_password}Password", "UTF-16LE")

    floppy_label = "cidata"
    
    floppy_content = {
      "/autounattend.xml" = templatefile("${path.cwd}/autounattend/${var.vm_name}/autounattend.xml.pkrtpl.hcl", {
        admin_password = local.admin_password
        logon_password = local.logon_password
      })
    }

    floppy_files = [
      "${path.cwd}/provision/scripts/pre-build/install-vmware-tools.ps1",
      "${path.cwd}/provision/scripts/pre-build/configure-winrm.ps1"
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
}

variable "os_version" {
  type = string
}

variable "os_type" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_url" {
  type = string
}

variable "iso_name" {
  type = string
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

variable "vnc_bind_address" {
  type = string
}

variable "vnc_port_min" {
  type = number
}

variable "vnc_port_max" {
  type = number
}

variable "is_vnc_disable_password" {
  type = bool
}

variable "winrm_username" {
    type = string
}

variable "winrm_password" {
    type = string
}

variable "winrm_port" {
  type = number
}

variable "is_winrm_use_ssl" {
  type = bool
}

variable "is_winrm_insecure" {
  type = bool
}

variable "winrm_timeout" {
  type = string
}