resource "libvirt_pool" "debian_pool" {
  provider = libvirt.construct01
  name     = "debian_bookworm_base"
  type     = "dir"
  target {
    path = "/opt/kvm/pools/debian_bookworm_base"
  }
}

resource "libvirt_volume" "debian_base" {
  provider = libvirt.construct01
  name     = "debian_bookworm"
  source   = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.qcow2"
  format   = "qcow2"
  pool     = libvirt_pool.debian_pool.name
}

module "_merovingian_kvm_guest" {
  source = "./modules/kvm_guest"
  providers = {
    libvirt = libvirt.construct01
  }
  base_os_volume_id = libvirt_volume.debian_base.id
  hostname          = "merovingian"
  volume_size       = 50
  memory            = 4096
  ipv4_address      = "10.1.1.100"
}

module "_morpheus_kvm_guest" {
  source = "./modules/kvm_guest"
  providers = {
    libvirt = libvirt.construct01
  }
  base_os_volume_id = libvirt_volume.debian_base.id
  hostname          = "morpheus"
  volume_size       = 25
  memory            = 2048
  ipv4_address      = "10.1.1.101"
}

module "_neo_kvm_guest" {
  source = "./modules/kvm_guest"
  providers = {
    libvirt = libvirt.construct01
  }
  base_os_volume_id = libvirt_volume.debian_base.id
  hostname          = "neo"
  volume_size       = 50
  memory            = 2048
  ipv4_address      = "10.1.1.102"
}

module "_link_kvm_guest" {
  source = "./modules/kvm_guest"
  providers = {
    libvirt = libvirt.construct01
  }
  base_os_volume_id = libvirt_volume.debian_base.id
  hostname          = "link"
  volume_size       = 25
  memory            = 2048
  ipv4_address      = "10.1.1.103"
}
