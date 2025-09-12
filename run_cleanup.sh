#!/bin/bash

# This script executes the cleanup playbook locally.

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="sdv_ansible_cleanup_${TIMESTAMP}.log"
exec &> >(tee -a "$LOG_FILE")

echo "Starting SDV Ansible cleanup on the local machine..."

# Assuming Ansible is already installed and the project is present
ansible-playbook cleanup.yml -c local

echo "SDV Ansible cleanup completed. Check $LOG_FILE for details."
