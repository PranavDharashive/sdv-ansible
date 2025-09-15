#!/bin/bash

# This script sets up Ansible on the remote host, downloads the SDV Ansible project,
# and executes the setup playbook locally.

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="sdv_ansible_run_${TIMESTAMP}.log"
exec &> >(tee -a "$LOG_FILE")

# Pass variables from interactive prompts to Ansible
read -p "Enter the private IP address of the Kube-apiserver endpoint: " KUBE_API_SERVER_IP < /dev/tty
if [ -z "$KUBE_API_SERVER_IP" ]; then
    echo "Kube-apiserver endpoint cannot be empty." >&2
    exit 1
fi
DEFAULT_K8S_VERSION="1.31"
read -p "Enter the Kubernetes version to install (default: ${DEFAULT_K8S_VERSION}, e.g., 1.30, 1.29): " KUBERNETES_VERSION < /dev/tty
KUBERNETES_VERSION=${KUBERNETES_VERSION:-$DEFAULT_K8S_VERSION}

# Check if a different version of Kubernetes is already installed
if command -v kubeadm &> /dev/null; then
    INSTALLED_KUBE_VERSION=$(kubeadm version -o short | sed 's/v//')
    if [[ ! "$INSTALLED_KUBE_VERSION" == "$KUBERNETES_VERSION"* ]]; then
        echo "Warning: An existing Kubernetes installation (version $INSTALLED_KUBE_VERSION) was found, but you are trying to install version $KUBERNETES_VERSION."
        read -p "It is highly recommended to run the cleanup.sh script first to avoid conflicts. Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborting. Please run ./cleanup.sh to remove the existing installation."
            exit 1
        fi
    fi
fi

echo "Starting SDV Ansible setup on the local machine..."

# 1. Install Ansible and its dependencies
echo "Installing Ansible and its dependencies..."
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible python3-pip

# Install kubernetes collection for Ansible
pip3 install kubernetes openshift
ansible-galaxy collection install kubernetes.core

# 2. Download the Ansible project
echo "Downloading the SDV Ansible project..."
# In a real scenario, this would involve `git clone` or `wget` a tarball.
# For this demonstration, we assume the project files are already present in the current directory.

# 3. Execute the site.yml playbook locally
echo "Executing the setup playbook..."

if ansible-playbook site.yml -c local \
  -e "kube_api_server_ip=$KUBE_API_SERVER_IP" \
  -e "kubernetes_version=$KUBERNETES_VERSION"; then
    echo "SDV Ansible setup completed successfully. Check $LOG_FILE for details."
else
    echo "SDV Ansible setup failed. Check $LOG_FILE for details." >&2
    exit 1
fi
