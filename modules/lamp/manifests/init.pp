class lamp {
  include php

  # Make sure all packages get installed.
  Package {
    ensure => 'installed',
  }

  # Apache
  package { 'apache2': }
  package { 'libapache2-mod-fastcgi': }
  service { 'apache2':
    require => Package['apache2'],
    ensure => running,
  }
  file { '/etc/apache2/conf-available/php5-fpm.conf' :
    source => 'puppet:///modules/lamp/php5-fpm.conf',
    require => Package['apache2'],
  }
  exec { 'a2enmod': command => '/usr/sbin/a2enmod actions fastcgi rewrite', require => Package['apache2']}
  exec { 'a2enconf': command => '/usr/sbin/a2enconf php5-fpm.conf', require => File['/etc/apache2/conf-available/php5-fpm.conf']}

  # MySQL
  class { '::mysql::server':
    override_options => { 'mysqld' => { 'max_allowed_packet' => '164M', 'collation-server' => 'utf8_general_ci', 'init-connect' => 'SET NAMES utf8', 'character-set-server' => 'utf8', 'innodb_flush_log_at_trx_commit' => '2'}, 'client' => {'default-character-set' => 'utf8'}, 'mysql' => {'default-character-set' => 'utf8'}}
  }

  # PHP
  class { ['php::fpm', 'php::cli', 'php::extension::memcached', 'php::extension::xdebug']:
  }
  package { 'php5-dev': }
  # ensure info.php file exists
  file { '/var/www/html/info.php':
    ensure => file,
    content => '<?php  phpinfo(); ?>',    # phpinfo code
    require => Package['apache2'],        # require 'apache2' package before creating
  }

  # Memcached
  package { 'memcached': }
  service { 'memcached':
    require => Package['memcached'],
    ensure => running,
  }

}