# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #
  # Try different boxes at your own peril.
  # Most provisioning will fail on non-Ubuntu boxes however.
  #
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Some more memory would be nice if we're running Symfony, APC and MySQL.
  # This could probably still need some tweaking.
  #
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  # Assuming this is obvious. Pick a port, any port.
  #
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # If you change the internal IP, make sure the provisioner also uses
  # that IP. (See the hosts file "development" in the root of /ansible.)
  #
  config.vm.network :private_network, ip: "192.168.111.100"

  # This maps ./projects to /home/vagrant/projects in the box.
  # It also ensures the synced directories are writable for for Apache.
  #
  # This avoids having to do all kinds of vagrant-specific stuff while provisioning,
  # and gives you the option to work both inside and outside the box.
  #
  config.vm.synced_folder "projects/", "/home/vagrant/projects", :owner => "vagrant", :group => "www-data", :extra => 'dmode=775,fmode=775'

  # Here you can change the playbook or the hosts file for Ansible.
  #
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/caas-development.yml"
    ansible.inventory_file = "ansible/development"
  end
end
