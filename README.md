PupPers
====

Personal Puppet configuration

Usage:

`sudo apt-get install puppet`

`sudo puppet module install willdurand/composer`

`sudo puppet module install puppetlabs-mysql`

`sudo puppet module install puppetlabs-git`

`sudo puppet module install nodes/php`

`sudo puppet apply --modulepath /etc/puppet/modules:./modules manifests/site.pp`

If you encounter errors after the first install, make sure modules are up to date:

`sudo puppet module upgrade puppetlabs-apt`
