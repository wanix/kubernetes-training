#!/bin/bash

export KUBELET_VERSION=1.19.2-0
export KUBEADM_VERSION=1.19.2-0
export KUBECTL_VERSION=1.19.2-0

# Disable Swap
swapoff -a
sed -i 's|^/swapfile|#/swapfile|' /etc/fstab

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Handle Yum

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum update -y
yum install -y vim net-tools wget yum-plugin-versionlock
cat <<EOF > /etc/yum/pluginconf.d/versionlock.list
# Kubernetes env for training
0:kubeadm-${KUBEADM_VERSION}.*
0:kubectl-${KUBECTL_VERSION}.*
0:kubelet-${KUBELET_VERSION}.*
EOF
yum install -y docker kubelet kubeadm kubectl --disableexcludes=kubernetes

# Enable routing
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Start services
systemctl enable --now docker
systemctl enable --now kubelet
