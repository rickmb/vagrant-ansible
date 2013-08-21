# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #
  # Try different boxes at your own peril.
  # Most provisioning will fail on non-Ubuntu boxes however.
  #
  # (If you don't have the box specified installed, it will
  #  be fetched from the given URL.)
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

  # This ensures that everything in the folder you share with the VM and your machine
  # is writeable for Apache:
  #
  # config.vm.synced_folder ".", "/vagrant", :owner => "vagrant", :group => "www-data", :extra => 'dmode=775,fmode=775'
  #
  # If you experience slow response times when running the site inside the VM, this may 
  # be because the syncing slows down dramatically with large numbers of files.
  # This is for instance the case with CaaS.
  #
  # You have three options:
  # 
  # 1. Deal with it.
  # 2. Work "remotely" over ssh instead, with an IDE that supports it of via sshfs.
  #    You may want to get used to that anyway if you also want to work on EC2 dev boxes.
  #    Also, sshfs is trivial to set up on OSX using OSXfuse (http://osxfuse.github.io/)
  # 3. Use NFS mount for the shared folder.
  #    The config below sets that up. Some caveats:
  #    - This won't work on Windows.
  #    - Your local machine should have NFS installed. OSX has this by default, and
  #      installing is trivial on most *nix boxes.
  #    - Upon starting the box you will be asked for the password of your local system.
  #    - Changing file ownership will not work on the NFS share. The config below ensures
  #      everything is writeable, but chown will crash.
  #
  config.vm.synced_folder ".", "/vagrant", :extra => 'dmode=777,fmode=777', :nfs => true

  # Here you can change the playbook or the hosts file for Ansible.
  #
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/caas-development.yml"
    ansible.inventory_file = "ansible/development"
    # Installs the "main" site for you. Remove if you don't want it.
    ansible.extra_vars = { sites: ["\'main\'"] }
    # Example of doing this for multiple sites:
    # ansible.extra_vars = { sites: ["\'opc\',\'main\',\'ebs\'"], foo: "bar" }
  end
end
