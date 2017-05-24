backend "consul" {
  address = "{{ ansible_eth1.ipv4.address }}:8500"
  cluster_addr = "http://{{ ansible_eth1.ipv4.address }}:8201"
  redirect_addr = "http://{{ ansible_eth1.ipv4.address }}:8200"
  path = "vault"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

disable_mlock = true
