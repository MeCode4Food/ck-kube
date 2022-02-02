## Getting Started

1. Generate a new key pair: `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/vm_local`
2. Run `vagrant up` to provision new VMs on target hardware
3. Run `ansible-playbook  ./kubernetes-setup/master-playbook.yml`
4. Run `ansible-playbook  ./kubernetes-setup/node-playbook.yml`
