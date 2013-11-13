# drupal-vagrant

This is a Vagrantfile and a set of puppet scripts for setting up a drupal dev environment.
It will install apache, mysql, php5 and drush, and configure them to serve the contents of ./public
at http://localhost:8080/

## Initial setup

 * Add a box called 'base' with Ubuntu 12.04 LTS.
   vagrant box add base http://files.vagrantup.com/precise64.box

## Setting up a clone of an existing old-style 'shared core' site

For this example I will use the 'strongerchristchurch.org.nz', and assume that you have a .sql database dump (ie, drush sql-dump)

 * Copy this repo somewhere. You need a seperate copy of the repo for each dev site
 * Clone the drupal core into ./public. strongerchristchurch needs a 6.x core, so:
    git clone git+ssh://locke.servers.catalyst.net.nz/git/public/drupal.git public
    cd public
    git checkout 6.x
 * Move the existing default site out of the way
    cd sites
    mv default default.old
 * Clone the repo for the existing site
    git clone git+ssh://locke.servers.catalyst.net.nz/git/private/drupal/strongerchristchurch.git default
 * SSH into the VM
    vagrant ssh
 * Import a database dump
    mysql -u root -p vagrant < dumpfile.sql
 * Create a settings.php file (easiest way is to copy one off the existing install)
 * Create a settings.php.db file
   <?php
	$db_url = 'mysql://vagrant:vagrant@localhost/vagrant';
	$db_prefix = '';
 * Many oldstyle sites have their modules at /home/drupal/contrib, with symlinks to folders in this folder checked into git. The 
   simplest way to replicate this to selectively clone from web2/3, and a script is provided for this:
    ./fix-missing-modules.sh
 * Clear the cache
   vagrant ssh
   cd /vagrant/public/sites/default
   drush cc all

## Details

This set of puppet scripts:
 * Installs Apache, MySQL, drush, apache2-mod-php5
 * Creates an Apache vhost to serve /vagrant/public on port 80
 * Forwards port 8080 to the VMs port 80
 * Creates a MySQL database called 'vagrant', with a user 'vagrant', password 'vagrant'
 * Adds the user 'www-data' to the group 'vagrant'
