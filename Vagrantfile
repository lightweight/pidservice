# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "base"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8086
  config.vm.network :forwarded_port, guest: 8080, host: 8090

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file base.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }
  #
  
  config.vm.provision :shell do |shell|
    shell.inline = "
      apt-get update;
      mkdir -p /etc/puppet/modules; 
      if [ ! -d /etc/puppet/modules/apache ]; then 
        puppet module install puppetlabs/apache; 
      fi;
      if [ ! -d /etc/puppet/modules/postgresql ]; then 
        puppet module install puppetlabs-postgresql; 
      fi;"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
  end

  config.vm.provision :shell do |shell|
    shell.inline = "
      export TOMCAT_HOME='/var/lib/tomcat6';
      if [ ! -d $TOMCAT_HOME/webapps/pidsvc.war ]; then 
        cd $TOMCAT_HOME/webapps;
        wget https://cgsrv1.arrc.csiro.au/swrepo/PidService/jenkins/trunk/pidsvc-latest.war;
        mv pidsvc-latest.war pidsvc.war; 
        chown -R tomcat6:tomcat6 $TOMCAT_HOME; 
      fi;";
  end

  config.vm.provision :shell do |shell|
    shell.args = ENV['pgpass'];
    shell.inline =" 
      export PGPASSWORD=$1;
      cd /vagrant/public;
      if [ ! -d /vagrant/public/PID ]; then 
        git svn clone https://www.seegrid.csiro.au/subversion/PID/ -T trunk -b branches -t tags; 
      fi;
      cd /vagrant/public/PID/pidsvc/src/main/db;
      if [ ! -f /vagrant/public/PID/pidsvc/src/main/db/postgresql.sql.orig]; then
        echo 'fixing postgresql.sql OWNER value';
        sed 's/pidsvc-admin/pidsvc/g' postgresql.sql > tmp.sql; 
        mv postgresql.sql postgresql.sql.orig; 
        mv tmp.sql postgresql.sql
      fi;
      if [ ! -f /vagrant/public/PID/pidsvc/src/main/db/postgresql.sql.orig]; then
        echo 'fixing createdb.sh OWNER value';
        sed 's/pidsvc-admin/pidsvc/g' createdb.sh > tmp.sh; 
        mv createdb.sh createdb.sh.orig; 
        mv tmp.sh createdb.sh
      fi;
      echo 'createlang';
      createlang -U pidsvc -h localhost plpgsql pidsvc;
      echo 'Importing sql';
      psql -U pidsvc  -h localhost -d pidsvc -f PID/pidsvc/src/main/db/postgresql.sql
      ";
  end

#/etc/tomcat6/Catalina/localhost/pidsvc.xml


  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision :chef_client do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
