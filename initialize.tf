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
