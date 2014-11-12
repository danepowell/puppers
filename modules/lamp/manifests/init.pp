class lamp {
  include apt

  # Make sure all packages get installed.
  Package {
    ensure => 'installed',
    require => Exec['apt-update'],
  }

  # Apache
  package { 'apache2': }
  package { 'libapache2-mod-fastcgi': }
  service { 'apache2':
    ensure => running,
  }
  file { '/etc/apache2/conf-available/php5-fpm.conf' :
    source => 'puppet:///modules/lamp/php5-fpm.conf',
    require => Package['apache2'],
  }

  # MySQL
  class { '::mysql::server':
    override_options => { 'mysqld' => { 'max_allowed_packet' => '164M', 'collation-server' => 'utf8_general_ci', 'init-connect' => 'SET NAMES utf8', 'character-set-server' => 'utf8', 'innodb_flush_log_at_trx_commit' => '2'}, 'client' => {'default-character-set' => 'utf8'}, 'mysql' => {'default-character-set' => 'utf8'}}
  }

  # PHP
  package { 'php5': }
  package { 'php5-fpm': }
  # ensure info.php file exists
  file { '/var/www/html/info.php':
    ensure => file,
    content => '<?php  phpinfo(); ?>',    # phpinfo code
    require => Package['apache2'],        # require 'apache2' package before creating
  }

  # Memcached
  package { 'memcached': }
  service { 'memcached':
    ensure => running,
  }
  package { 'php5-memcached': }

}