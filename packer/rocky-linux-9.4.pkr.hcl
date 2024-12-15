# -----------------------------------------------------------------------------
# Packer Configuration for Creating a Rocky Linux 9.4 VirtualBox VM
# -----------------------------------------------------------------------------
#
# This Packer configuration automates the creation of a VirtualBox VM running
# Rocky Linux 9.4. It uses a specific ISO image for installation and provisions
# the system after the installation completes.
#
# Key Points:
# - The configuration is designed to work with VirtualBox as the hypervisor.
# - The VM installation is fully automated using a Kickstart file for unattended
#   installation.
# - After the installation, a shell provisioning script (`scripts/rocky9_setup.sh`)
#   is executed to perform additional setup tasks.
#
# The variables section allows you to customize the VM name, memory, CPU count,
# and disk size for the VM. You can also specify a custom ISO URL and checksum 
# for the Rocky Linux installation ISO.
#
# -----------------------------------------------------------------------------
# Instructions:
# 1. To initialize the Packer environment, run:
#    packer init rocky-linux-9.4.pkr.hcl
#
# 2. To build the image, run:
#    packer build -var vm_name=rocky-linux-9-4-gm rocky-linux-9.4.pkr.hcl
#
# 3. Ensure that the `scripts/rocky9_setup.sh` provisioning script is created
#    and contains the necessary setup steps you need for the VM.
# 4. Place the `ks.cfg` (Kickstart file) in the `http` directory so it can be
#    served during installation for automated setup.
# -----------------------------------------------------------------------------

# Variables for easier configuration
variable "iso_url" {
  type    = string
  default = "Rocky-9.4-x86_64-dvd.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:E20445907DAEFBFCDB05BA034E9FC4CF91E0E8DC164EBD7266FFB8FDD8EA99E7"
}

variable "vm_name" {
  type    = string
  default = "rocky-linux-9-4"
}

variable "vm_memory" {
  type    = number
  default = 2048
}

variable "vm_cpus" {
  type    = number
  default = 1
}

variable "vm_disk_size" {
  type    = number
  default = 10240
}

# Define the required plugins for Packer
packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

# Define the VirtualBox ISO builder
source "virtualbox-iso" "rocky_linux" {
  # Basic VM configuration
  vm_name           = var.vm_name
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  output_directory  = "output-virtualbox-{{timestamp}}"
  shutdown_command  = "sudo poweroff"
  guest_os_type     = "Linux_64"
  disk_size         = var.vm_disk_size
  memory            = var.vm_memory
  cpus              = var.vm_cpus

  # SSH settings
  ssh_username      = "packer"  # Set SSH username for the VM
  ssh_password      = "packer"  # Provide SSH password (or use SSH keys if preferred)
  ssh_timeout       = "15m"     # Timeout for SSH connection

  # HTTP directory for Kickstart file
  http_directory    = "../packer/http"

  # Boot command to automatically pass the kickstart file to the installer
  boot_command = [
    "<tab><wait>",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>"
  ]
}

# Define the build block that ties the source to provisioners
build {
  sources = [
    "source.virtualbox-iso.rocky_linux"
  ]
  
  # Copy packer public key to GM
  # Created with ssh-keygen -b 2048 -t rsa -C 'packer' -f packer
  provisioner "file" {
  source = "packer-key.pub"
  destination = "/tmp/packer.pub"
}


  # Provisioning script to set up the system after boot
  provisioner "shell" {
    script = "../packer/scripts/rocky9_setup.sh"
  }
}
