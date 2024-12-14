<#
    Script Description / Notes:

    This PowerShell script automates the process of downloading and preparing resources for use with HashiCorp Packer, 
    as well as creating an SSH key for Packer's use. Here's a breakdown of what the script does:

    Usage:
    - The script is designed to be run in a PowerShell environment.
    - Ensure that the script is executed in a directory where the ..\local directory can be created (the parent directory should exist).
    - After execution, the Rocky-9.4-x86_64-dvd.iso, packer.zip, and packer-key files will be available in the ..\local directory 
      for use in automation tasks (e.g., using Packer to build virtual machine images).
#>

$rockyISO = "https://dl.rockylinux.org/vault/rocky/9.4/isos/x86_64/Rocky-9.4-x86_64-dvd.iso"
$packerEXE = "https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_windows_amd64.zip"

# create local directory to store resources not in code
mkdir "..\local"

# download rocky iso
Invoke-WebRequest $rockyISO -OutFile "..\local\Rocky-9.4-x86_64-dvd.iso"

#download packer
Invoke-WebRequest $packerEXE -OutFile "..\local\packer.zip"

#extract packer
Expand-Archive -Path "..\local\packer.zip" -DestinationPath "..\local" -Force

#generate packer cert
ssh-keygen -b 2048 -t rsa -C "packer" -f "..\local\packer-key"
