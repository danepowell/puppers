include apt

# Make sure all packages get installed.
Package {
  ensure => 'installed',
  require => Exec['apt-update'],
}

# LAMP stack
class { 'lamp': }

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
