# Assignment 4 --- System Manager Ansible Role

## 📌 Overview

This project demonstrates a reusable **System Manager Ansible Role**
used to configure and manage a Linux VM automatically.

The role performs system bootstrap tasks including:

-   Software installation
-   User and group management
-   Git repository management
-   Folder structure creation
-   Service management
-   Environment configuration
-   SSH hardening

------------------------------------------------------------------------

## 🏗️ Project Structure

    assignment4/
    │
    ├── inventory
    ├── playbook.yml
    │
    └── system_manager/
            ├── defaults/main.yml
            ├── tasks/
            │   ├── main.yml
            │   ├── packages.yml
            │   ├── users.yml
            │   ├── directories.yml
            │   ├── git.yml
            │   ├── services.yml
            │   ├── sysconfig.yml
            │   └── ssh.yml
            ├── handlers/main.yml
            └── templates/env.sh.j2

------------------------------------------------------------------------

## ⚙️ Features Implemented

  Feature                 Description
  ----------------------- -----------------------------------------
  Package Management      Install required software automatically
  User Management         Create users & groups
  Git Management          Clone repositories
  Directory Setup         Create required folders
  Service Management      Start & enable services
  Environment Variables   Configure system environment
  SSH Security            Disable root login & password auth

------------------------------------------------------------------------

## 🚀 How to Run

### 1️⃣ Configure Inventory

    [servers]
    ec2 ansible_host=<EC2_PUBLIC_IP> ansible_user=ubuntu

### 2️⃣ Run Playbook

    ansible-playbook -i inventory site.yml

------------------------------------------------------------------------

## ✅ Verification Commands

### Verify Packages

    which nginx
    which git

### Verify Users

    id dev1
    id dev2

### Verify Directories

    ls -ld /opt/projects

### Verify Git Repository

    ls /opt/projects/springapp

### Verify Services

    systemctl status nginx

### Verify Environment Variables

    cat /etc/profile.d/custom_env.sh

### Verify SSH Configuration

    grep PermitRootLogin /etc/ssh/sshd_config

------------------------------------------------------------------------

## 🔁 Idempotency Check

Run playbook again:

    ansible-playbook -i inventory site.yml

Expected output:

    changed=0

------------------------------------------------------------------------

## 📸 Results / Screenshots

![](images/1.png)


