# drupal-vagrant

This is a Vagrantfile and a set of puppet scripts for setting up a drupal dev environment.
It will install apache, mysql, php5 and drush, and configure them to serve the contents of ./public
at http://localhost:8080/

## Initial setup

 * Add a box called 'base' with Ubuntu 12.04 LTS.
   vagrant box add base http://files.vagrantup.com/precise64.box

## Setting up a clone of a new 'single-core' style site

 * Copy this repo somewhere. You need a seperate copy of the repo for each dev site
    e.g. git clone git+ssh://git.catalyst.net.nz/git/private/vagrant-drupal.git vagrant-drupal-cera.govt.nz
 * Clone the Drupal site you want into ./public
    e.g. git clone git+ssh://git.catalyst.net.nz/git/private/drupal/cera.git public
 * cd vagrant-drupal-cera.govt.nz
 * Build the new machine instance. With multiple vagrant instances you may need to edit the Vagrant file to change port 8080 to (say) 8081.
    vagrant up
 * Provision PHP, Apache, MySQL, drush etc. using puppet.
    vagrant provision
 * SSH into the vm
    vagrant ssh
    cd /vagrant/public
 * Create settings.db.php if needed.
    Drupal 6:
    <?php
      $db_url = array();
      $db_url['default'] = 'mysql://vagrant:vagrant@localhost/vagrant';
      $db_prefix = ''
 * Import a database dump
    mysql -u root -p vagrant < dumpfile.sql
 * Create the relevent settings files
 * Clear the cache
    drush cc all

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

## Solr

You can install Apache Solr in your VM by running (after you have done 'vagrant up'):
  
  solr=true vagrant provision
  
This will:
 * Install the OpenJDK JRE
 * Download and unpack Solr 4.5.1 (the latest stable version at time of writing) to /opt/solr-4.5.1
 * chown /opt/solr-4.5.1 to vagrant:vagrant
 * Forward port 8983 to the VM
 
To start Solr:
 cd /opt/solr-4.5.1/example
 java -jar start.jar --daemon &
 
You can then access the Solr admin at http://localhost:8983/solr
