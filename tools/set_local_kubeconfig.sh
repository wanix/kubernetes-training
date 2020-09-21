#!/bin/sh
KUBECONFIG=$(cd $(dirname $0)/..; pwd)/.kubeconfig
vagrant ssh kube-master -c "sudo cat /etc/kubernetes/admin.conf" 2>/dev/null > ${KUBECONFIG}
IPADDR=$(vagrant ssh kube-master -c "ip addr show eth1 | grep 'inet ' | sed 's/  */ /g' | cut -d ' ' -f 3 | cut -d '/' -f 1" 2>/dev/null | sed 's/\r//g')
if [ -n "${IPADDR}" ];
then
  grep -q ' k8smaster$' /etc/hosts
  if [ $? -eq 0 ];
  then
    sudo sed -i "/ k8smaster$/c${IPADDR} k8smaster" /etc/hosts
  else
    sudo sed -i -e "$ a${IPADDR} k8smaster" /etc/hosts
  fi
fi
echo "Please add or verify k8smaster in your /etc/hosts: $IPADDR"
grep " k8smaster$" /etc/hosts
echo "Please do the following command on your laptop:"
echo "  export KUBECONFIG=${KUBECONFIG}"

