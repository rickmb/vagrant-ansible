# Vagrant + Ansible for WEBclusive dev

## Requirements

* **Vagrant**. Get it at http://www.vagrantup.com
* **Virtualbox**. https://www.virtualbox.org
* **Ansible**. Get it at http://www.ansibleworks.com. Okay, this is somewhat hidden because Ansible wants to sell you stuff. Find instructions in the documentation (http://www.ansibleworks.com/docs/gettingstarted.html#getting-ansible). For me, installing Ansible via Macports went smoothly on OSX.


## Usage

1. Clone this repo.
1. Pick a Vagrant config (Vagrantfile.*) to start with by copying it to "Vagrantfile".
1. Edit **Vagrantfile** to your liking. Or at least read it so you know what's going to happen.
1. Type **vagrant up**
1. If you're using NFS for your sync folder, you're likely to be prompted for you *local* password early in the process. This is because Vagrant needs to edit /etc/exports.
1. Get some coffee.
1. ...
1. Seriously, get that coffee. If this is the first time you're initializing this box, this is may take a while.
1. ...
1. Also, if you're provisioning the caas-development.yml playbook, you might as well grab a bite to eat. Installing CaaS for the first time takes ages.

The result will depend on your Vagrantfile settings and the playbook you selected. The current default is a complete CaaS development environment including the "main" site up and running at http://main-caas.local.webclusive.net:8080 . (*.local.webclusive.net points to 127.0.0.1). Also, if you go to http://127.0.0.1:8080, there will be some basic info there.

*Note: Vagrant may report a failure from Ansible despite showing 0 failed tasks. This is a known issue in the Vagrant Ansible module, it doesn't hurt and will be fixed in later releases.*

## Contents

* **VagrantFile** : Vagrant configuration.
* **ansible/** : The Ansible provisioning definitions, a.k.a. "playbooks".

### Vagrantfile

This is the configuration for Vagrant. Just read the comments. Pay special attention to:

* The **config.vm.synced_folder** setting. Your preference may vary depending on your system, workflow and project.
* The **ansible.playbook** setting. Look in /ansible/*.yml for various alternatives.

There are a few flavors in this repo:
* **Vagrantfile.Lite** : A simple LAMP box.
* **Vagrantfile.Dev** : A simple LAMP box with some common development tools.
* **Vagrantfile.CaasDev** : A CaaS development box, with optional auto-install of CaaS sites. *Please note that because of the size of CaaS, this config uses NFS for the shared directory. This will not work on Windows, check the config for alternative options.*

### ansible/

This folder contains the Ansible playbooks, which describe what the resulting machine should look like. Everything could easily fit in a single YAML file, but by splitting it up in the standard Ansible layout it becomes easier to put different playbooks together and keeping it DRY.

It currently contains the following:

* **development** : This file contains the hosts Ansible has to provision for development. It's just a single entry with the IP address of the Vagrant box.
* **caas-development.yml** : This is the playbook for a CaaS development box. It's basically just a lot of "roles" to be applied. Just read the file.
* **development.yml** : This is the playbook for a pretty much standard PHP development box.
* **roles/** : This contains various partial playbooks for specific purposes. The structure is based on Ansible's best practices guide and defaults. Some of these roles are ridiculously simple, but splitting them up this way allows re-use without duplication.

The roles folder structure makes the Ansible playbook look a bit more complex than it really is. For instance, 95% of what you need for a LAMP system is all in this single file: https://github.com/rickmb/vagrant-ansible/blob/master/ansible/roles/common/tasks/main.yml

#### roles/

##### common/

Basic LAMP stuff every PHP project needs. Apache, PHP, modules, etcetera. Please note that this does not include MySQL server. That's a separate role, allowing us to provision boxes that don't need MySQL or use an external DB-server.

##### dbserver/

Guess what?

##### development/

Stuff we need for development, but try to avoid installing on production systems (although we tend to be lazy about that separation). For instance Git, Sass/Compass, etcetera.

##### caas-development/

Installs CaaS on the system. This includes everything from cloning it from Github, setting up the directories and running composer.
Also, it can optionally set up CaaS sites for you with the optional variable "sites" (see Vagrantfile).

Code is installed on /vagrant/projects, which is synced with your local system on /projects.

**Notes about the automatic set-up of CaaS and CaaS sites**
* If there is already a git checkout of CaaS, it will neither be updated nor overwritten.
* Apache configs are created as /etc/apache2/sites-available/caas-dev-{site}, but existing ones are not overwritten.
* sites/{sites}/paramaters.yml is installed, but not overwritten if there is already one there.
* A database caas_{site} is created, but only if not already there.
* The database is populated with the dummy data only if the Ansible has just created the database.

In other words: if you re-run vagrant provision after you've made changes, any changes you've made to the data or configuration will remain untouched as much as possible.

#### group_vars/

Contains variables per hosts group.

##### vagrant

Defines some vagrant specific stuff, like the path to the users home directory and where to install projects.

## About the sync/share directory


## TODO

* Make the playbook more robust (especially when it comes to re-running provision on an existing box)
* Create a playbook for setting up an EC2 instance instead of a Vagrant box.
* Create playbooks for simulating CaaS production environments.
* Create playbooks for simulating Fundrz/9apps environments.

