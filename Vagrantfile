# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vagrant.plugins =  [ "vagrant-vbguest" ]
  config.ssh.config = "./ssh_client_config"
  # Configuration
  nb_masters = 1
  nb_workers = 2
  bridge_interface = "wlp59s0"
  # bridge_interface = "enxe4b97ad0fa7f"

  # Common VM configuration

  config.vm.box = "centos/7"
  config.vm.network :public_network, type: "dhcp", bridge: bridge_interface
  config.vm.network :private_network, type: "dhcp"

  # Configure master LB
  if nb_masters > 1
    config.vm.define "kube-lb" do |lb|
      lb.vm.hostname = "kube-lb"
      lb.vm.provider :virtualbox do |v|
        v.name = "kube-lb"
        v.cpus = 1
        v.memory = 1024
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
    end
  end

  # Configure Kubernetes masters node
  (1..nb_masters).each do |i|
    config.vm.define "kube-master-#{i}" do |master|
      master.vm.hostname = "kube-master-#{i}"
      master.vm.provider :virtualbox do |v|
        v.name = "kube-master-#{i}"
        v.cpus = 2
        v.memory = 2048
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
    end
    config.vm.provision "shell", name: "prepare-kubeadm", path: "./prepare-for-kube.sh"
  end

  # Configure Kubernetes workers nodes

  (1..nb_workers).each do |i|
    config.vm.define "kube-worker-#{i}" do |worker|
      worker.vm.hostname = "kube-worker-#{i}"
      worker.vm.provider :virtualbox do |v|
        v.name = "kube-worker-#{i}"
        v.cpus = 2
        v.memory = 3072
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
    end
    config.vm.provision "shell", name: "prepare-kubeadm", path: "./prepare-for-kube.sh"
 end
end
