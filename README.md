# Vagrant + Ansible for WEBclusive development

## Requirements

* **Vagrant**. Get it at http://www.vagrantup.com
* **Virtualbox**. https://www.virtualbox.org
* **Ansible**. Get it at http://www.ansibleworks.com. Okay, this is somewhat hidden because Ansible wants to sell you stuff. Find instructions in the documentation (http://www.ansibleworks.com/docs/gettingstarted.html#getting-ansible). For me, installing Ansible via Macports went smoothly on OSX.


## Usage

1. Clone this repo.
1. Edit Vagrantfile. Or at least read it so you know what's going to happen.
1. Type "vagrant up".
1. Get some coffee.
1. ...
1. Seriously, get that coffee. If this is the first time you're initializing this box, this is going to take a while.
1. ...

The result will depend on your Vagrantfile settings and the playbook you selected. The current default is a complete CaaS development environment including the "main" site up and running at http://main-caas.local.webclusive.net:8080 . (*.local.webclusive.net points to 127.0.0.1). Also, if you go to http://127.0.0.1:8080, there will be some basic info there.

## Contents

* **VagrantFile** : Vagrant configuration.
* **ansible/** : The Ansible provisioning definitions, a.k.a. "playbooks".
* **projects/** : This is your working directory. it will be synced in the Vagrant box with /home/vagrant/projects.

### Vagrantfile

This is the configuration for Vagrant. Just read the comments.

### ansible/

This folder contains the Ansible playbooks, which describe what the resulting machine should look like. Everything could fit in a single YAML file, but by splitting it up in the standard Ansible layout it becomes easier to put different playbooks together.

It currently contains the following:

* **development** : This file contains the hosts Ansible has to provision for development. It's just a single entry with the IP address of the Vagrant box.
* **caas-development.yml** : This is the playbook for a CaaS development box. It's basically just a lost of "roles" to be applied. Just read the file.
* **roles/** : This contains various partial playbooks for specific purposes. The structure is based on Ansible's best practices guide and defaults. Some of these roles are ridiculously simple, but splitting them up this way allows re-use without duplication.

The roles folder structure makes the Ansible playbook look a bit more complex than it really is. For instance, 95% of what you need for a LAMP system is all in this single file: https://github.com/rickmb/vagrant-ansible/blob/master/ansible/roles/common/tasks/main.yml

#### roles/

##### common

Basic LAMP stuff every PHP project needs. Apache, PHP, modules, etcetera. Please note that this does not include MySQL server. That's a separate role, allowing us to provision boxes that don't need MySQL or use an external DB-server.

##### dbserver

Guess what?

##### development

Stuff we need for development, but try to avoid installing on production systems (although we tend to be lazy about that separation). For instance Git, Sass/Compass, etcetera.

##### caas-development

Installs CaaS on the system. This includes everything from cloning it from Github to installing a running version of the "main" site and database.

Code is installed on /home/vagrant/projects, which is synced with your local system on /projects.

## Questions (and possible answers)
*There are no stupid questions, just a lot of inquisitive idiots.*

### What if I want my workspace (/projects) elsewhere?

On your local system, all you have to do is change the local path declared in the Vagrantfile. If you already have the Vagrant box running, you should bring it down first before doing that.

If you want to change the path inside the Vagrant box however, you will not only have to change the path in the Vagrantfile, but also adjust where the Ansible playbooks install their stuff. Start by editting ansible/group_vars/vagrant. If all playbooks play nice, this is all you have to do. However, this is completely untested.

I would also suggest destroying the VM (vagrant destroy) and bringing it back up if you do this on a running box.


## TODO

* Complete this documentation.
* Make it possible to easily pre-select which CaaS-sites to configure.
* Make the playbook more robust.
* Add some playbooks for basic non-CaaS projects. (Which is basically just omitting the caas-development role.)
* Create a playbook for setting up an EC2 instance instead of a Vagrant box.
* Create a playbook for simulating CaaS production environments.

