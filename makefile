init:
	vagrant up

list-master-snapshots:
	vagrant snapshot list kube-master

save:
	vagrant halt
	vagrant snapshot save $(snapshot)
	vagrant up

restore:
	vagrant halt
	vagrant snapshot restore $(snapshot)
	vagrant up

tear-down:
	vagrant destroy

