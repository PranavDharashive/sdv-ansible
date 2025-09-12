I. Core Automation Framework using Ansible, shell scripts, kubernetes manifests, jinja templates etc.
   1. Single Command/Minimal Steps: Create an automation solution for installation and configuration. ask for kube api endpoint and kubernetes version as an input to script, interactive input. These scripts will be directly download on the remote host or VM and run there as a running locally on that VM, so consider like that.
   2. Cleanup Scripts: Provide scripts for cleanup if installation fails or for general teardown.
   3. Target Operating System: Ubuntu 22.04 LTS.
   4. Logging: Store all execution logs into a single file.
   5. Documentation: Create a README.md file detailing prerequisites and execution steps.
   6. Kube-apiserver Endpoint Input: Prompt for the private IP address of the Kube-apiserver endpoint during installation.
   7. Final Success Message: Display a summary of successfully deployed components upon completion.

  II. Kubernetes Cluster Setup:
   1. Kubeadm Prerequisites:
       * Setup kubeadm prerequisites.
       * Consider containerd as the container runtime and also I want to setup docker runtime both on this single node, i want to run docker for other apps and containerd for kubernetes, make sure that docker and container both will be running and using "systemd" as a cgroup driver for both
       * Include specific commands: sudo swapoff -a, sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab, sudo tee
         /etc/modules-load.d/containerd.conf, sudo modprobe overlay, sudo modprobe br_netfilter, sudo tee /etc/sysctl.d/kubernetes.conf, sudo
         sysctl --system.
   2. Single Node Cluster: Setup a kubeadm single-node cluster.
   3. Kubernetes Version: Install Kubernetes version specified by user for kubelet, kubeadm, and kubectl.
   4. CNI Plugin: Use Calico CNI instead of Flannel.
   5. Node Taint Removal: Ensure the node-role.kubernetes.io/control-plane:NoSchedule taint is removed from the control plane node so
      applications can be deployed on it. The taint removal step should be idempotent (skipped if already removed).
   6. Kubeconfig Configuration: Configure kubeconfig for the current user running Ansible, not just root.

  III. Application Deployments & Verification:
   1. Monitoring Stack:
       * Install Prometheus Node Exporter on the VM.
       * Deploy Prometheus and Grafana on k8s in the monitoring namespace.
       * Verify Node Exporter setup.
       * Verify monitoring stack deployment.
   2. Redis Service:
       * Create an sdv namespace.
       * Deploy a single-pod Redis service with its Kubernetes service in the sdv namespace.
       * Verify Redis setup.
   3. MySQL Service:
       * Create /mnt/mysql-db-data/ directory on the VM.
       * Create a local storage class named sdv-local-storage.
       * Deploy MySQL on k8s using PV and PVC with the sdv-local-storage class.
       * Verify MySQL setup, create sdv_data database, create user sdvuser with password abcd1234, grant all privileges, and flush privileges.
       * Specific handling for PV/PVC: Ensure nodeAffinity is correctly templated and handled for local PVs, with graceful failure and user
         instructions if an immutable PV is encountered.
   4. SDV Application:
       * Deploy an sdv application using nginx:latest image and its Kubernetes service in the sdv namespace.
       * Verify sdv app deployment.
   5. SDV Nginx/Frontend Application:
       * Deploy an Nginx/frontend app using nginx:latest image with a NodePort service in the sdv namespace.
       * Verify SDV Nginx/frontend app deployment.
   6. MinIO Service:
       * Create /mnt/minio-storage/ directory.
       * Create a minio namespace.
       * Deploy MinIO on k8s with a local volume and its Kubernetes service.
       * Specific handling for PV/PVC: Ensure nodeAffinity is correctly templated and handled for local PVs, with graceful failure and user
         instructions if an immutable PV is encountered.
   7. General Verification: All pod status checks should be robust, including checking status.containerStatuses[0].ready.

  IV. Cleanup Script Enhancements:
   1. Kubernetes Package Removal: Unhold and remove kubeadm, kubectl, kubelet packages, allowing changes to held packages.
   2. Directory Removal: Remove /etc/kubernetes, $HOME/.kube, /var/lib/etcd, /etc/containerd, and /etc/cni directories.
   3. Persistent Data Exclusion: Do NOT remove /mnt/mysql-db-data/ and /mnt/minio-storage/ directories.
   4. Iptables Flush: Flush iptables rules (iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X).

  This comprehensive set of requirements has guided the development of the Ansible playbooks and helper scripts.