import "apache"

class { 'apache':
  default_vhost => false,
  mpm_module => 'prefork',
}

apache::vhost { 'localhost':
  docroot => '/vagrant/public',
  priority => 0,
  port => 80,
}

class {'apache::mod::php':}

class { '::mysql::server':
  root_password    => 'vagrant',
}

mysql::db { 'vagrant':
  user => 'vagrant',
  password => 'vagrant',
  host => 'localhost',
  grant => 'all',
  }
