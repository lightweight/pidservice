$packages = [
             "git",
             "etckeeper",
             "tomcat6",
             "tomcat6-admin",
             "mysql-server",
             ]

package { $packages:
  ensure  => installed,
}

file { "/var/lib/fedora":
  ensure  => directory,
  owner   => tomcat6,
  group   => tomcat6,
  mode    => 2750,
}

file { "/var/lib/solr":
  ensure  => directory,
  owner   => tomcat6,
  group   => tomcat6,
  mode    => 2750,
}

file { "/var/log/fedora":
  ensure  => directory,
  owner   => tomcat6,
  group   => tomcat6,
  mode    => 2750,
}
