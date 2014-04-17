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

$packages = [
             "git",
             "git-svn",
             "etckeeper",
             "tomcat6",
             "tomcat6-admin",
             ]

package { $packages:
  ensure  => installed,
}

class { 'postgresql::server': }

#postgresql::server::role { 'vagrant':
#  createdb => true,
#  password_hash => postgresql_password('vagrant', 'vagrant'),
#}

postgresql::server::db { 'pidsvc':
  user     => 'pidsvc',
  password => postgresql_password('pidsvc', 'vagrant'),
}

file { "/etc/tomcat6/webapps":
  ensure  => directory,
  owner   => tomcat6,
  group   => tomcat6,
  mode    => 2750,
}

#postgresql::server::database_grant { 'pidsvc':
#  privilege => 'ALL',
#  db        => 'pidsvc',
#  role      => 'pidsvc',
#}

#wget https://www.seegrid.csiro.au/subversion/PID/trunk/pidsvc/src/main/db/postgresql.sql
#psql -d pidsvc -f postgresql.sql


User <| title == "www-data" |> {
  groups +> 'vagrant',
}
