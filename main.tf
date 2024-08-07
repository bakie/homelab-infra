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

# Run script to download and extract image file before uploading to glance
resource "null_resource" "download-extract-image-home-assistant-os" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/home_assistant_image.sh"
  }
}

resource "libvirt_pool" "pool_home_assistant" {
  name = "home_assistant_os"
  type = "dir"
  path = "/opt/kvm/pools/home_assistant_os"
}

resource "libvirt_volume" "home_assistant_volume" {
  name   = "home_assistant_os"
  source = pathexpand("~/.terraform/image_cache/haos_9.4.qcow2")
  format = "qcow2"
  pool   = libvirt_pool.pool_home_assistant.name
  depends_on = [
    null_resource.download-extract-image-home-assistant-os
  ]
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

module "_home_assistant_guest" {
  source            = "./modules/kvm_guest"
  base_os_volume_id = libvirt_volume.home_assistant_volume.id
  firmware          = "/usr/share/OVMF/OVMF_CODE.fd"
  hostname          = "home_assistant"
  volume_size       = 48
  memory            = 2048
  ipv4_address      = "10.1.1.103"
}

resource "libvirt_pool" "debian_pool" {
  name = "debian_bookworm_base"
  type = "dir"
  path = "/opt/kvm/pools/debian_bookworm_base"
}

resource "libvirt_volume" "debian_base" {
  name   = "debian_bookworm"
  source = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.qcow2"
  format = "qcow2"
  pool   = libvirt_pool.debian_pool.name
}

module "_merovingian_kvm_guest" {
  source            = "./modules/kvm_guest"
  base_os_volume_id = libvirt_volume.debian_base.id
  hostname          = "merovingian"
  volume_size       = 10
  memory            = 512
  ipv4_address      = "10.1.1.111"
}
