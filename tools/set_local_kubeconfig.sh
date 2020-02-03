#!/bin/sh
KUBECONFIG=$(cd $(dirname $0)/..; pwd)/.kubeconfig
vagrant ssh kube-master -c "sudo cat /etc/kubernetes/admin.conf" > ${KUBECONFIG}
echo "export KUBECONFIG=${KUBECONFIG}"
