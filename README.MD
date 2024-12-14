# Derrick's Home Lab Automation Repository

This repository contains scripts and configurations for automating the setup and management of a home lab environment. It includes tools for building virtual machines, configuring a Kubernetes environment with **K3s**, installing and configuring **AWX** (Ansible Tower), and provisioning AWX job templates to manage Kubernetes clusters.

## Table of Contents
1. [Overview](#overview)
2. [Directory Structure](#directory-structure)
3. [Prerequisites](#prerequisites)
4. [Usage](#usage)
5. [Configuration](#configuration)

---

## Overview

This repository provides various automation tools for setting up and managing a home lab environment. The key areas of automation include:

- **Packer Scripts**: Automates the creation of virtual machines (GMs) for your home lab.
- **Miscellaneous Bash Scripts**: Helps with environment kickstart tasks such as disk extension and setting up initial services.
- **Ansible Playbooks**: Used for building a Kubernetes environment using **K3s**, installing **AWX** in the **K3s** cluster, and configuring AWX.
- **AWX Job Templates**: Provision job templates to automate tasks such as Kubernetes cluster creation.

## Directory Structure

The repository is organized into the following directories and files:

### `packer/`
Contains **Packer HCL files** for automated GM creation.

- `http/`: Contains **Rocky Kickstart Scripts** for setting up the operating system on the VMs.
- `scripts/`: Contains **bootstrapping scripts** that are executed after the kickstart scripts complete, setting up the necessary services and configurations.

### `powershell/`
Contains **miscellaneous PowerShell scripts** that help in automating common tasks in the lab setup.

- `bootsrap.ps1`: A script used to bootsrap Packer by downloading Rocky Linux 9 ISO and HashiCorp Packer.

---

## Prerequisites

Before using these scripts, make sure you have the following installed and configured:

- **VirtualBox**: Ansible Tower that is deployed in the K3s cluster to automate jobs.
- **GitHub PAT (Personal Access Token)**: Required to authenticate with GitHub for any SCM operations (if using GitHub for playbook or project retrieval).


---

## Usage

### Step 1 - Clone this repo
```bash
git clone https://github.com/dfoos/local-lab.git
```                                                                                                                                                                                
### Step 2 - Run bootsrap.ps1
1. Navigate to the `powershell/` directory.
2. Run the PowerShell bootstrap script:                                                                                               
```powershell
./bootstrap.ps1
```                                                                                                       
### Step 3 - Build Packer image
1. Navigate to the newly create `local/` directory.
2. Run the Packer build command:                                                                                               
```bash
packer build -var vm_name=rocky-linux-9-4-gm packer/rocky-linux-9.4.pkr.hcl
```
