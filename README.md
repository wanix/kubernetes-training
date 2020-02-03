# kubernetes-training

This repository provides some infrastructure code based on Vagrant & Virtualbox to get a basic infrastructure useable for
the LFS258 Kubernetes fundamentals training.

## Prerequisites

* Vagrant
* Virtualbox
* Bridge networking: we use public networking to expose Kubernetes API Server

This setup was used on a Macos based workstation.
I believe the Vagrant part of this repository will work fine on any machine that support Virtualbox & Vagrant.

## Configuration

As of now there is few configuration options available except:
* configure the number of Kubernetes worker you want to have. Default: 1
* configure the network interface that will be used as a bridge.
    * The default value suits my personal rig: *there are good chances that you need to update this configuration.*

Those options are set in the Vagrantfile directly.

## Usage

### Spin up a local infrastructure for the training

You can use the following make target to start the whole infrastructure.

```bash
# Spin up the nodes
make init

# Snapshot Kubernetes master in case of
make save snapshot=before-kubeadm
```

### Connect to the instances

You can connect to the instances through the following commands:

* Kubernetes master node: `vagrant ssh kube-master`
* Kubernetes worker node: `vagrant ssh kube-worker-1`
* If you asked for more workers they will be available using the same pattern as for the previous worker
    * e.g.: `kube-worker-2`, ...

### Creating the cluster

The Kubernetes fundamentals training will guide through the usage of `kubeadm` so I won't tell that much about it.

Note that sometimes `kubeadm init` will pick the wrong network interface & bind Kubernetes API server to the NAT
interface `10.0.2.15`.

If this happens:
* Reset the master node by either:
  * `sudo kubeadm reset`
  * or use the make target `make restore snapshot=before-kubeadm`
* Fetch your public IP out of `ip addr`. This one should be set on the *eth1* interface
* Use the `--apiserver-advertise-address` option during `kubeadm init`
Example:

``` bash
kubeadm init --kubernetes-version 1.15.0 --pod-network-cidr 192.168.0.0/16 --apiserver-advertise-address $(ip addr show eth1 | grep 'inet ' | sed 's/  */ /g' | cut -d ' ' -f 3 | cut -d '/' -f 1)
```

You can also see with `kubectl get nodes -o wide` that the INTERNAL-IP can be also the NAT one

``` bash
kubectl get nodes -o wide
NAME            STATUS   ROLES    AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
kube-master     Ready    master   22h   v1.15.0   10.0.2.15      <none>        CentOS Linux 7 (Core)   3.10.0-957.21.3.el7.x86_64   docker://1.13.1

sudo sed -i "s/KUBELET_EXTRA_ARGS=/KUBELET_EXTRA_ARGS=--node-ip=$(ip addr show eth1 | grep 'inet ' | sed 's/  */ /g' | cut -d ' ' -f 3 | cut -d '/' -f 1)/g" /etc/sysconfig/kubelet; sudo systemctl daemon-reload; sudo systemctl restart kubelet

kubectl get nodes -o wide
NAME            STATUS   ROLES    AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
kube-master     Ready    master   22h   v1.15.0   172.28.128.3   <none>        CentOS Linux 7 (Core)   3.10.0-957.21.3.el7.x86_64   docker://1.13.1
```

You may have to do that also for the workers

After establishing the cluster:
* make sure that you follow `kubeadm` instructions to move the Kubernetes config
  file to your user inside the Kubernetes master node
* create a snapshot for Kubernetes master: it could help you later if you screw up
  * `make save snapshot=after-kubeadm`

### Fetch the Kubernetes config file for local usage

You can use the following commands in order to use your own terminal/shell to work with this cluster

Note: you must have followed `kubeadm` instructions about moving the Kubernetes configuration file to the user home.

```
vagrant ssh kube-master -c "sudo cat /etc/kubernetes/admin.conf" > /tmp/vagrant.kube.config
export KUBECONFIG=/tmp/vagrant.kube.config
```

### Restore Kubernetes master

If by any chance you wreck your Kubernetes cluster you can restore the Kubernetes nodes back to a previous snapshot: `make restore snapshot=after-kubeadm-init`.

 This example restores back to the moment you have just established the cluster though you can create more snapshots whenever you want to.
 
As for the workers: you can simply kill them &

### Tear down the infrastructure

When you don't need it anymore:`make tear-down`

## Usefull links

* Program: https://www.cncf.io/certification/cka/

* Handbook: https://www.cncf.io/certification/candidate-handbook

* Curriculum: https://github.com/cncf/curriculum/raw/master/certified_kubernetes_administrator_exam_v1.9.0.pdf

* Github: https://github.com/cncf/curriculum

* Kubectl Cheatsheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

* My Google drive resources (limited accesses): https://drive.google.com/drive/u/0/folders/1zjKh1BMi-SqPfxdg9vRWa_9uzGszOEvu


### CKA related

* Curriculum: https://github.com/cncf/curriculum/raw/master/certified_kubernetes_administrator_exam_v1.9.0.pdf

* Exam Tips: https://www.cncf.io/certification/tips

* https://dev.to/scriptautomate/tips-for-the-certified-kubernetes-exams-cka-and-ckad-49mn

* https://medium.com/@imarunrk/certified-kubernetes-administrator-cka-tips-and-tricks-part-1-2e98e9b31de4

* https://medium.com/platformer-blog/how-i-passed-the-cka-certified-kubernetes-administrator-exam-8943aa24d71d

* https://levelup.gitconnected.com/kubernetes-cka-hands-on-challenge-2-scheduler-playground-f6c0ea7389ca
