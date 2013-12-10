import "apache"

class { 'apache':
  default_vhost => false,
  mpm_module => 'prefork',
}

apache::vhost { 'localhost':
  docroot => '/vagrant/public',
  priority => 0,
  port => 80,
  override => ["All"],
}

class {'apache::mod::php':}
class {'apache::mod::rewrite':}

class { '::mysql::server':
  root_password    => 'vagrant',
}

mysql::db { 'vagrant':
  user => 'vagrant',
  password => 'vagrant',
  host => 'localhost',
  grant => ['ALL'],
  }

package { ['php5-mysql', 'php-pear','htop','php5-gd','php5-curl','php5-json','git']:
  ensure => present,
  }

file { ["/home/drupal","/home/drupal/contrib","/home/drupal/libraries"]:
  ensure => 'directory',
  owner => 'www-data',
  group => 'www-data',
}

File["/home/drupal"] -> File["/home/drupal/contrib"] -> File["/home/drupal/libraries"]

User <| title == "www-data" |> {
  groups +> 'vagrant',
}

exec { "/usr/bin/pear channel-discover pear.drush.org && /usr/bin/pear install drush/drush && /usr/bin/drush --version":
  creates => "/usr/bin/drush",
  require => Package["php-pear"],
}
