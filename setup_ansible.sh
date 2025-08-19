#!/bin/bash

# Папка проекта
PROJECT_DIR=~/ansible_project

# Создаем структуру директорий
mkdir -p $PROJECT_DIR/playbooks
mkdir -p $PROJECT_DIR/roles/docker/tasks
mkdir -p $PROJECT_DIR/roles/docker/handlers
mkdir -p $PROJECT_DIR/roles/docker/defaults
mkdir -p $PROJECT_DIR/inventories

# ===== INVENTORY =====
cat > $PROJECT_DIR/inventories/hosts.ini <<EOL
[local]
vm-netology ansible_connection=local
EOL

# ===== ANSIBLE.CFG =====
cat > $PROJECT_DIR/ansible.cfg <<EOL
[defaults]
inventory = ./inventories/hosts.ini
roles_path = ./roles
remote_user = netologyadmin
host_key_checking = False
retry_files_enabled = False
EOL

# ===== PLAYBOOK =====
cat > $PROJECT_DIR/playbooks/install_docker.yml <<EOL
---
- name: Install Docker using role
  hosts: all
  become: yes
  roles:
    - docker
EOL

# ===== ROLE: tasks/main.yml =====
cat > $PROJECT_DIR/roles/docker/tasks/main.yml <<EOL
---
- name: Install required packages
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
    state: present
    update_cache: yes

- name: Add Docker GPG key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker repository
  apt_repository:
    repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
    state: present

- name: Install Docker
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    state: latest
    update_cache: yes
  notify: Restart Docker

- name: Install Docker Compose Plugin
  apt:
    name: docker-compose-plugin
    state: latest
    update_cache: yes
EOL

# ===== ROLE: handlers/main.yml =====
cat > $PROJECT_DIR/roles/docker/handlers/main.yml <<EOL
---
- name: Restart Docker
  service:
    name: docker
    state: restarted
EOL

# ===== ROLE: defaults/main.yml =====
cat > $PROJECT_DIR/roles/docker/defaults/main.yml <<EOL
---
docker_version: "latest"
EOL

echo "Структура Ansible создана в $PROJECT_DIR с ролью docker и установкой Docker Compose Plugin"
echo "Теперь можно запустить плейбук:"
echo "cd $PROJECT_DIR && ansible-playbook playbooks/install_docker.yml"
