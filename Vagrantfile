# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vagrant.plugins =  [ "vagrant-vbguest" ]
  config.ssh.config = "./ssh_client_config"
  # Configuration
  nb_workers = 3
  bridge_interface = "wlp59s0"
  # bridge_interface = "enxe4b97ad0fa7f"

  # Common VM configuration

  config.vm.box = "centos/7"
  config.vm.network :public_network, type: "dhcp", bridge: bridge_interface
  config.vm.network :private_network, type: "dhcp"
  config.vm.provision "shell", name: "prepare-kubeadm", path: "./prepare-for-kube.sh"

  # Configure Kubernetes master node
  config.vm.define "kube-master" do |master|
    master.vm.hostname = "kube-master"
    master.vm.provider :virtualbox do |v|
      v.name = "kube-master"
      v.cpus = 4
      v.memory = 6144
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
  end

  # Configure Kubernetes workers nodes

  (1..nb_workers).each do |i|
    config.vm.define "kube-worker-#{i}" do |worker|
      worker.vm.hostname = "kube-worker-#{i}"
      worker.vm.provider :virtualbox do |v|
        v.name = "kube-worker-#{i}"
        v.cpus = 2
        v.memory = 6144
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
    end
 end
end
