resource "libvirt_pool" "pool" {
  name = var.hostname
  type = "dir"
  path = "/opt/kvm/pools/${var.hostname}"
}

resource "libvirt_volume" "volume" {
  name           = var.hostname
  pool           = libvirt_pool.pool.name
  size           = var.volume_size * 1000000000
  base_volume_id = var.base_os_volume_id
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/cloud_init.cfg")
  vars = {
    hostname = var.hostname
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/templates/network_config.cfg")
  vars = {
    ipv4_address = var.ipv4_address
  }
}

resource "libvirt_cloudinit_disk" "cloudinit_data" {
  name           = "${var.hostname}_cloudinit_data"
  pool           = libvirt_pool.pool.name
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}


resource "libvirt_domain" "domain" {
  name      = var.hostname
  memory    = var.memory
  vcpu      = var.vcpus
  cloudinit = libvirt_cloudinit_disk.cloudinit_data.id
  #cloudinit = templatefile("${path.module}/templates/cloud_init.cfg.tpl", {})
  autostart = true

  disk {
    volume_id = libvirt_volume.volume.id
  }

  network_interface {
    bridge = "br0"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}
