# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |v|
    v.memory = 384
  end

  config.vm.define "vault01" do |box|
    box.vm.hostname = "vault01"
    box.vm.network "private_network", ip: "10.10.10.11"
    box.vm.provision :shell, path: "resources/scripts/bootstrap_ansible.sh"
    box.vm.provision :shell, inline: "cd /vagrant && PYTHONUNBUFFERED=1 ansible-playbook vault.yml -c local"
  end

  config.vm.define "vault02" do |box|
    box.vm.hostname = "vault02"
    box.vm.network "private_network", ip: "10.10.10.12"
    box.vm.provision :shell, path: "resources/scripts/bootstrap_ansible.sh"
    box.vm.provision :shell, inline: "cd /vagrant && PYTHONUNBUFFERED=1 ansible-playbook vault.yml -c local"
  end

  config.vm.define "vault03" do |box|
    box.vm.hostname = "vault03"
    box.vm.network "private_network", ip: "10.10.10.13"
    box.vm.provision :shell, path: "resources/scripts/bootstrap_ansible.sh"
    box.vm.provision :shell, inline: "cd /vagrant && PYTHONUNBUFFERED=1 ansible-playbook vault.yml -c local"
  end

  config.vm.provision :vai do |ansible|
    ansible.inventory_dir = './'
    ansible.inventory_filename = 'hosts'
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
end
