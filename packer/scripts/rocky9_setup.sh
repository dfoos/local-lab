#!/bin/bash
# This script sets up additional packages and services for the system

# Enable the EPEL (Extra Packages for Enterprise Linux) repository
sudo dnf install epel-release -y

# Add the VirtualBox repository for installation
sudo dnf config-manager --add-repo=https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo

# Update the system to ensure all packages are up-to-date
sudo dnf -y update

# Install essential packages: vim, wget, curl, net-tools, git, make, and tar
sudo dnf -y install vim wget curl net-tools git make tar

# Install VirtualBox (version 7.0)
sudo dnf install VirtualBox-7.0 -y

# Enable and start the SSH service to allow remote connections
sudo systemctl enable --now sshd

# Copy packer ssh key
sudo mkdir /home/packer/.ssh
sudo cp /home/packer/.ssh/authorized_keys /home/packer/.ssh/authorized_keys.bak
sudo mv /tmp/packer.pub /home/packer/.ssh/authorized_keys
sudo chown packer:packer /home/packer/.ssh
sudo chmod 600 /home/packer/.ssh/authorized_keys
sudo chmod 700 /home/packer/.ssh
# Remove packer ssh key
# rm -f /tmp/packer.pub

# Executes the 'update-crypto-policies' command with no parameters, which updates the system's cryptographic policy to the default policy (DEFAULT). 
sudo update-crypto-policies
