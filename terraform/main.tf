# Proxmox Provider
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_node_name" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

variable "proxmox_ssh_key" {
  type = string
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

###################################################
# Ubuntu 22.04 vm --> ubuntu-vm1 (using template) #
###################################################
resource "proxmox_vm_qemu" "ubuntu_vm1" {
  name = "ubuntu-vm1"
  desc = "Ubuntu 22.0.4 vm with some tools installed"
  vmid = "210"
  target_node = var.proxmox_node_name

  full_clone = true
  clone = "ubuntu-22-04-template"

  onboot = false
  oncreate = true
  agent = 1

  network {
    bridge = "vmbr0"
    model = "virtio"
    firewall = "false"    
    }
  
  disk {
    type = "scsi"
    size = "20G"
    storage = "storage"
  }

  cpu = "host"
  cores = 2
  memory = 2048

  os_type = "cloud-init"
  ipconfig0 = "ip=192.168.1.50/24,gw=192.168.1.127"

  ciuser = "ubuntu"
  #cipassword = "ubuntu"
  sshkeys = <<EOF
  ${var.proxmox_ssh_key}
  EOF

  #provisioner "local-exec" {
  #  command = ""
  #}
  
}

###################################################
# Debian 11 ct --> debian-ct1 (no template)       #
###################################################
resource "proxmox_lxc" "debian_ct1" {
  hostname = "debian-ct1"
  description = "Debian 11 ct"
  vmid = "110"
  target_node = var.proxmox_node_name
  ostemplate = "local:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst"
  unprivileged = true

  features {
    nesting = true
  }

  network {
    name = "eth0"
    bridge = "vmbr0"
    ip = "192.168.1.10/24"
    gw = "192.168.1.127"
  }
  
  rootfs {
    storage = "storage"
    size = "10G"
  }

  cores = 1
  memory = 1024
  swap = 0

  ssh_public_keys = <<-EOT
  ${var.proxmox_ssh_key}
  EOT

  start = true
  
  #provisioner "local-exec" {
  #  command = ""
  #}
}

