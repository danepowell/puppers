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

package { 'mysql-server':
  require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,
}

service { 'mysql':
  ensure => running,
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

exec { 'drush-install':
  command => '/usr/local/bin/composer global require drush/drush:6.*'
}

package { 'php5-fpm'
  ensure => installed,
}
