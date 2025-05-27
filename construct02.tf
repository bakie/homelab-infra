resource "libvirt_pool" "debian_pool_construct02" {
  provider = libvirt.construct02
  name     = "debian_bookworm_base"
  type     = "dir"
  target {
    path = "/opt/kvm/pools/debian_bookworm_base"
  }
}

resource "libvirt_volume" "debian_base_construct02" {
  provider = libvirt.construct02
  name     = "debian_bookworm"
  source   = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.qcow2"
  format   = "qcow2"
  pool     = libvirt_pool.debian_pool_construct02.name
}

module "_docker_test_kvm_guest" {
  source = "./modules/kvm_guest"
  providers = {
    libvirt = libvirt.construct02
  }
  base_os_volume_id = libvirt_volume.debian_base_construct02.id
  hostname          = "docker_test"
  volume_size       = 50
  memory            = 4096
  ipv4_address      = "10.1.1.110"
}
