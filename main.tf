resource "libvirt_pool" "pool" {
  name = "ubuntu_20.04_base"
  type = "dir"
  path = "/opt/kvm/pools/ubuntu_20.04_base"
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu_20.04"
  source = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
  pool   = libvirt_pool.pool.name
}

module "_pihole_kvm_guest" {
  source            = "./modules/kvm_guest"
  base_os_volume_id = libvirt_volume.ubuntu_base.id
  hostname          = "pihole"
  volume_size       = 10
  memory            = 512
  ipv4_address      = "10.1.1.99"
}

module "_prometheus_kvm_guest" {
  source            = "./modules/kvm_guest"
  base_os_volume_id = libvirt_volume.ubuntu_base.id
  hostname          = "prometheus"
  volume_size       = 30
  memory            = 4096
  ipv4_address      = "10.1.1.100"
}

module "_satan_kvm_guest" {
  source            = "./modules/kvm_guest"
  base_os_volume_id = libvirt_volume.ubuntu_base.id
  hostname          = "satan"
  volume_size       = 30
  memory            = 1024
  ipv4_address      = "10.1.1.101"
}

module "_lucifer_kvm_guest" {
  source            = "./modules/kvm_guest"
  base_os_volume_id = libvirt_volume.ubuntu_base.id
  hostname          = "lucifer"
  volume_size       = 20
  memory            = 1024
  ipv4_address      = "10.1.1.102"
}
