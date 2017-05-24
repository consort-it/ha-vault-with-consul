#!/bin/bash

set -e

if [ ! -f /root/.ansible-installed ]; then
  echo "Installing Ansible..."
  apt-get install -y software-properties-common
  apt-add-repository ppa:ansible/ansible
  apt-get update
  apt-get install -y --force-yes ansible
  cp /vagrant/ansible.cfg /etc/ansible/ansible.cfg
  touch /root/.ansible-installed
  echo "Cleaning up APT..."
  apt-get autoremove --purge -y && apt-get autoclean
fi
