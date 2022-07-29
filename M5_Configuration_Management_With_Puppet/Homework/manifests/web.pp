$packages = [ 'httpd', 'php', 'php-mysqlnd' ]

package { $packages: }

service { httpd:
  ensure => running,
  enable => true,
}

file { '/var/www/html':
  ensure => directory,
  recurse => true,
  source => "/vagrant/web",
}

class { 'firewall': }

firewall { '000 accept 80/tcp':
  action   => 'accept',
  dport    => 80,
  proto    => 'tcp',
}

selboolean { 'Apache SELinux':
  name       => 'httpd_can_network_connect', 
  persistent => true, 
  provider   => getsetsebool, 
  value      => on, 
}
