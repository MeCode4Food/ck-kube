IMAGE_NAME = "bento/ubuntu-16.04"
N = 2
HOST_PREFIX = "192.168.56"
SSH_PUB_KEY_DEST = "/home/vagrant/.ssh/id_rsa.pub"
SSH_PUB_KEY_SRC = File.expand_path("~/.ssh/vm_local.pub")


Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end
      
    config.vm.define "k8s-master" do |master|
        master.vm.hostname = "k8s-master"
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "#{HOST_PREFIX}.10"
        # designate port forward port
        master.vm.network "forwarded_port", id: "ssh", guest: 22, host: 2220

        ssh_pub_key = "/home/vagrant/.ssh/vm_local.pub"
        master.vm.provision "file", source: SSH_PUB_KEY_SRC, destination: ssh_pub_key
        master.vm.provision "shell", inline: <<-SHELL
          sudo apt update
          if grep -sq "#{ssh_pub_key}" /home/vagrant/.ssh/authorized_keys; then
            echo "SSH keys already provisioned."
            exit 0;
          fi
          echo "SSH key provisioning."
          mkdir -p /home/vagrant/.ssh/
          touch /home/vagrant/.ssh/authorized_keys
          cat #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          cat #{ssh_pub_key} > /home/vagrant/.ssh/id_rsa.pub
          chmod 644 /home/vagrant/.ssh/id_rsa.pub
          chown -R vagrant:vagrant /home/vagrant
          exit 0
        SHELL
        # master.vm.provision "ansible" do |ansible|
        #     ansible.playbook = "kubernetes-setup/master-playbook.yml"
        #     ansible.extra_vars = {
        #         host_prefix: HOST_PREFIX,
        #         node_ip: "#{HOST_PREFIX}.10",
        #     }
        # end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "#{HOST_PREFIX}.#{i + 10}"
            node.vm.network "forwarded_port", id: "ssh", guest: 22, host: 2220 + i
            node.vm.hostname = "node-#{i}"

            
            ssh_pub_key = "/home/vagrant/.ssh/vm_local.pub"
            node.vm.provision "file", source: "../vm_local.pub", destination: ssh_pub_key
            node.vm.provision "shell", inline: <<-SHELL
            sudo apt update
            if grep -sq "#{ssh_pub_key}" /home/vagrant/.ssh/authorized_keys; then
                echo "SSH keys already provisioned."
                exit 0;
            fi
            echo "SSH key provisioning."
            mkdir -p /home/vagrant/.ssh/
            touch /home/vagrant/.ssh/authorized_keys
            cat #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
            cat #{ssh_pub_key} > /home/vagrant/.ssh/id_rsa.pub
            chmod 644 /home/vagrant/.ssh/id_rsa.pub
            chown -R vagrant:vagrant /home/vagrant
            exit 0
            SHELL
            # node.vm.provision "ansible" do |ansible|
            #     ansible.playbook = "kubernetes-setup/node-playbook.yml"
            #     ansible.extra_vars = {
            #         host_prefix: HOST_PREFIX,
            #         node_ip: "#{HOST_PREFIX}.#{i + 10}",
            #     }
            # node.vm.network "forwarded_port", guest: 23, host: 4021 + i 
            # end
            node.vm.provision "file", source: SSH_PUB_KEY_SRC, destination: SSH_PUB_KEY_DEST
        end
    end
end
