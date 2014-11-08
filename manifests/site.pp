exec { 'apt-update':                    # exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}

package { 'apache2':
  require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,
}

service { 'apache2':
  ensure => running,
}

class { '::mysql::server':
  override_options => { 'mysqld' => { 'max_allowed_packet' => '164M', 'collation-server' => 'utf8_general_ci', 'init-connect' => 'SET NAMES utf8', 'character-set-server' => 'utf8', 'innodb_flush_log_at_trx_commit' => '2'}, 'client' => {'default-character-set' => 'utf8'}, 'mysql' => {'default-character-set' => 'utf8'}}
}

package { 'php5':
  require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,
}

# ensure info.php file exists
file { '/var/www/info.php':
  ensure => file,
  content => '<?php  phpinfo(); ?>',    # phpinfo code
  require => Package['apache2'],        # require 'apache2' package before creating
}

# Expect is required by aht
package { 'expect':
  require => Exec['apt-update'],
  ensure => installed,
}

package { 'memcached':
  require => Exec['apt-update'],
  ensure => installed,
}

service { 'memcached':
  ensure => running,
}

package { 'php5-memcached':
  require => Exec['apt-update'],
  ensure => installed,
}

package { 'bundler':
  ensure   => installed,
  provider => gem,
}

# required by ffi gem
package { 'ruby-dev':
  ensure => installed,
}

# required for bacon
package { 'ffi':
  ensure => installed,
  provider => gem,
  require => Package['ruby-dev'],
}

class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin'
}

package { 'php5-fpm':
  ensure => installed,
}
