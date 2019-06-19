init:
	vagrant up

list-master-snapshots:
	vagrant snapshot list kube-master

save-master:
	vagrant halt kube-master
	vagrant snapshot save kube-master $(snapshot)
	vagrant up kube-master

restore-master:
	vagrant halt kube-master
	vagrant snapshot restore kube-master $(snapshot)
	vagrant up kube-master

tear-down:
	vagrant destroy

