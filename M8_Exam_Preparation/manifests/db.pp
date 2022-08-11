class { '::mysql::server':
  root_password => '12345',
  remove_default_accounts => true,
  restart => true,
  override_options => {
    mysqld => { bind-address => '0.0.0.0' }
  },
}

mysql::db { 'bulgaria':
  user => 'root',
  password => '12345',
  dbname => 'bulgaria',
  host => '%',
  sql => '/vagrant/apps/bgapp/db/db_setup.sql',
  enforce_sql => true,
}

mysql::db { 'trackvisits':
  user => 'root',
  password => '12345',
  dbname => 'trackvisits',
  host => '%',
  sql => '/vagrant/apps/trackvis/db/db_setup.sql',
  enforce_sql => true,
}

class { 'firewall': }

firewall { '000 accept 3306/tcp':
  action => 'accept',
  dport => 3306,
  proto => 'tcp',
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
