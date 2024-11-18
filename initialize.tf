terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri   = "qemu+ssh://${var.kvm_construct01_user}@${var.kvm_construct01_hostname}/system?known_hosts_verify=ignore"
  alias = "construct01"
}


#provider "libvirt" {
#  uri = "qemu+ssh://${var.kvm_user}@${var.kvm_hostname}/system"
#}
#terraform {
#  required_providers {
#    proxmox = {
#      source  = "telmate/proxmox"
#      version = "3.0.1-rc4"
#    }
#    vault = {
#      source  = "hashicorp/vault"
#      version = "4.3.0"
#    }
#  }
#}
#
#provider "proxmox" {
#  pm_api_url      = "https://${var.proxmox_host}:8006/api2/json"
#  pm_tls_insecure = true
#}
