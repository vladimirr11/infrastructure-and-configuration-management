class { '::mysql::server':
  root_password           => '12345',
  remove_default_accounts => true,
  restart                 => true,
  override_options => {
    mysqld => { bind-address => '0.0.0.0' }
  },
}

mysql::db { 'bulgaria-db':
  user        => 'root',
  password    => '12345',
  # dbname      => 'bulgaria',
  host        => '%',
  sql         => '/vagrant/db/db_setup.sql',
  enforce_sql => true,
}

class { 'firewall': }

firewall { '000 accept 3306/tcp':
  action   => 'accept',
  dport    => 3306,
  proto    => 'tcp',
}
