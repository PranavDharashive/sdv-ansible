# SDV Ansible Automation

This project automates the setup of a single-node Kubernetes cluster and deploys various applications using Ansible.

## Prerequisites

- Ubuntu 22.04 LTS
- Internet connection (for downloading Ansible and project files).

## Execution

1.  **Download the project files** to your remote Ubuntu 22.04 LTS VM.
    (e.g., `git clone <repository_url>` or `wget <tarball_url>`).

2.  **Make the scripts executable:**
    ```bash
    chmod +x install.sh cleanup.sh
    ```

3.  **Run the setup script:**
    ```bash
    ./install.sh
    ```
    You will be prompted for the Kube-apiserver IP and Kubernetes version.
    All execution logs will be stored in `sdv_ansible_run.log`.

4.  **Run Cleanup Script (Optional):**
    To clean up the environment, run the cleanup script:
    ```bash
    ./cleanup.sh
    ```
    Cleanup logs will be in `sdv_ansible_cleanup.log`.
