
package { "openjdk-6-jre-headless":
  ensure => present,
}

exec { "solr-download":
  command => "/usr/bin/wget http://apache.insync.za.net/lucene/solr/4.5.1/solr-4.5.1.tgz && /bin/tar -xf solr-4.5.1.tgz && chown -R vagrant:vagrant solr-4.5.1.tgz"
  cwd => "/opt",
  creates => "/opt/solr-4.5.1.tgz",
}


