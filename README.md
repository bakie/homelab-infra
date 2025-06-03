# Homelab Infra

This is my simple homelab infra setup using [KVM](https://www.linux-kvm.org/page/Main_Page) and managing the VM's via [OpenTofu](https://opentofu.org/).

# Table of content
* [Requirements](#requirements)
* [Installing KVM on Debian 12 bookworm](#installing-kvm-on-debian-12-bookworm)
* [Running OpenTofu](#running-opentofu)

## Requirements
* A machine running [KVM](https://www.linux-kvm.org/page/Main_Page)
* [OpenTofu](https://opentofu.org/)

## Installing KVM on Debian 12 bookworm
## Prerequisites
Run the following to install some basic packages and add the user to the sudo group
```
$ apt install vim aptitude sudo htop netcat-openbsd --no-install-recommends
$ usermod -aG sudo ikke
```
### Install QEMU-KVM and libvirt
Setup the virtualization environment
```
$ apt install libvirt-daemon libvirt-daemon-system libvirt-dev libosinfo-bin libguestfs-tools qemu-kvm virtinst bridge-utils --no-install-recommends
```

### Start and enable the libvirt service
```
$ systemctl start libvirtd
$ systemctl enable libvirtd
```

### Modprobe vhost_net
modprobe vhost_net and add it to /etc/modules to improve the performance of network data transfer
```
$ modprobe vhost_net
$ echo vhost_net | tee -a /etc/modules
```

### Make the host-bridge network and active and autostart it
Create the following file `/var/lib/libvirt/networks/host-bridge.xml` (you must first create the networks dir!) with the content 
```
<network>
  <name>host-bridge</name>
  <forward mode="bridge"/>
  <bridge name="br0"/>
</network>
```

Define the new host-bridge network, start it and make it autostart
```
$ virsh net-define host-bridge.xml 
$ virsh net-start host-bridge
$ virsh net-autostart host-bridge
```

Check if the host-bridge is active
```
$ virsh net-list --all
```

If the host-bridge is active remove the default network. The net-destroy command is only required if the 'default' network is active.
```
$ virsh net-destroy default
$ virsh net-undefine default
```

### Create bridge network on host
To be able to access the KVM virtual machines out of the host we need to create a bridge network interface. We create the bridge interface over the physical nic of the host system. Use `ip a` to find the physical network interface. In my case the name is `enp114s0`.

Next edit the interfaces file
```
$ vim /etc/network/interfaces
```

Make the file look like this. Note: Change the ip address and netmask etc to match the local network configuration.
```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto br0
iface br0 inet static
  bridge_ports enp114s0
	address 10.1.1.100
	netmask 255.255.255.0
	broadcast 10.1.1.255
	gateway 10.1.1.1
	bridge_stp off
	bridge_maxwait 5
	dns-nameservers 10.1.1.1
```

### Disable qemu security_driver
If we leave the security driver to SELinux we will get permission denied errors when creating new VM's. We will disable the security driver as this is not a security risk for home usage.

Edit the file `/etc/libvirt/qemu.conf` and look for security_driver and change it to `none`
```
security_driver = "none"
```

### (optional) Install cockpit
Cockpit is a server administration tool to manage KVM virtual machines.
```
$ apt install cockpit cockpit-machines --no-install-recommends
```

Enable and start cockpit
```
$ systemctl enable cockpit.socket
$ systemctl start cockpit.socket
```

### (Optional) add user to libvirt and kvm group
Add the user to the libvirt and kvm groups so we don't need root privileges to manage virtual machines
```
$ usermod -aG libvirt ikke
$ usermod -aG kvm ikke
```

### Reboot the system
```
$ reboot
```

## Running OpenTofu
When using it for the first time, first initialize OpenTofu. This will download the required files for the libvirt provider.
```
$ tofu init
```

Run tofu apply to apply the changes to KVM
```
$ tofu apply
```
