provider "libvirt" {
  uri = "qemu+ssh://${var.kvm_user}@${var.kvm_hostname}/system"
}