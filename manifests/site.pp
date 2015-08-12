include git

# Make sure all packages get installed.
Package {
  ensure => 'installed',
}

# LAMP stack
class { 'lamp': }

# Requirements for AHT
package { 'expect': }
package { 'openjdk-8-jre':}
package { 'openjdk-8-jdk':}

class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin'
}

# emacs
package { 'emacs':}
package { 'auto-complete-el':}
package { 'php-elisp':}
package { 'yaml-mode':}

# git
git::config { 'user.name':
  value => 'Dane Powell',
}

git::config { 'user.email':
  value => 'git@danepowell.com',
}

package { 'tig':}

package { 'xclip':
}
