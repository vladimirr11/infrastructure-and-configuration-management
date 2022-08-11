$packages = [ 'httpd', 'php', 'php-mysqlnd' ]

package { $packages: }

file { '/etc/httpd/conf.d/vhost-bgapp.conf':
  ensure => present,
  source => "/vagrant/config/vhost-bgapp.conf",
}

file { '/etc/httpd/conf.d/vhost-trackvis.conf':
  ensure => present,
  source => "/vagrant/config/vhost-trackvis.conf",
}

file { '/var/www/bgapp':
  ensure => 'directory'
}

file { '/var/www/trackvis':
  ensure => 'directory'
}

file { '/var/www/bgapp/index.php':
  ensure => present,
  source => "/vagrant/apps/bgapp/web/index.php",
}

file { '/var/www/bgapp/config.php':
  ensure => present,
  source => "/vagrant/apps/bgapp/web/config.php",
}

file { '/var/www/bgapp/bulgaria-map.png':
  ensure => present,
  source => "/vagrant/apps/bgapp/web/bulgaria-map.png",
}

file { '/var/www/trackvis/index.php':
  ensure => present,
  source => "/vagrant/apps/trackvis/web/index.php",
}

file { '/var/www/trackvis/config.php':
  ensure => present,
  source => "/vagrant/apps/trackvis/web/config.php",
}

class { 'firewall': }

firewall { '000 accept 8081/tcp':
  action   => 'accept',
  dport    => 8081,
  proto    => 'tcp',
}

firewall { '000 accept 8082/tcp':
  action   => 'accept',
  dport    => 8082,
  proto    => 'tcp',
}

class { selinux:
  mode => 'permissive'
}

file_line { 'hosts-web':
  ensure => present,
  path => '/etc/hosts',
  line => '192.168.99.101 web.do2.lab web',
  match => '^192.168.99.101',
}

file_line { 'hosts-db':
  ensure => present,
  path => '/etc/hosts',
  line => '192.168.99.102 db.do2.lab db',
  match => '^192.168.99.102',
}

service { httpd:
  ensure => running,
  enable => true,
}

# selboolean { 'Apache SELinux':
#   name       => 'httpd_can_network_connect', 
#   persistent => true, 
#   provider   => getsetsebool, 
#   value      => on, 
# }
