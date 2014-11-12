exec { 'apt-update':                    # exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}

# Make sure all packages get installed.
Package {
  ensure => 'installed',
  require => Exec['apt-update'],
}

# LAMP stack
package { 'apache2': }
service { 'apache2':
  ensure => running,
}
class { '::mysql::server':
  override_options => { 'mysqld' => { 'max_allowed_packet' => '164M', 'collation-server' => 'utf8_general_ci', 'init-connect' => 'SET NAMES utf8', 'character-set-server' => 'utf8', 'innodb_flush_log_at_trx_commit' => '2'}, 'client' => {'default-character-set' => 'utf8'}, 'mysql' => {'default-character-set' => 'utf8'}}
}
package { 'php5': }
# ensure info.php file exists
file { '/var/www/info.php':
  ensure => file,
  content => '<?php  phpinfo(); ?>',    # phpinfo code
  require => Package['apache2'],        # require 'apache2' package before creating
}
package { 'memcached': }
service { 'memcached':
  ensure => running,
}
package { 'php5-memcached': }
package { 'php5-fpm': }


# Requirements for AHT
package { 'expect': }
package { 'openjdk-7-jre':}
package { 'openjdk-7-jdk':}

package { 'bundler':
  provider => gem,
}

# required by ffi gem
package { 'ruby-dev':
}

# required for bacon
package { 'ffi':
  provider => gem,
  require => Package['ruby-dev'],
}

class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin'
}

# emacs
package { 'emacs':}
package { 'auto-complete-el':}
package { 'php-elisp':}
