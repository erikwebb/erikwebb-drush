# == Class: drush
#
# Install Drush.
#
# === Parameters
#
# [*version*]
#   Specify a Drush version to install.
#
# === Examples
#
#   class { 'drush':
#     version => '5.8.0',
#   }
#
# === Authors
#
# Erik Webb <erik@erikwebb.net>
#
# === Copyright
#
# Copyright 2013 Erik Webb, unless otherwise noted.
#
class drush(
  $version = 'latest'
) {

  # Setup Drush for following tasks.
  include pear

  pear::package { 'PEAR': }
  pear::package { 'Console_Table': }

  # Version numbers are supported.
  pear::package { 'drush':
    version    => $version,
    repository => 'pear.drush.org',
  }
  
  exec { 'drush.autocomplete.install':
    command  => 'for DRUSH_PATH in $(php -i | grep "include_path" | cut -d">" -f3 | cut -d: -f2- | sed "s/:/\n/g; /^ *$/d;"); do [ -f "${DRUSH_PATH%*/}/drush/drush.complete.sh" ] && ln -s -f "${DRUSH_PATH%*/}/drush/drush.complete.sh" /etc/bash_completion.d/drush.complete.sh && break; done',
    provider => shell,
    onlyif   => 'which bash',
    path     => [
      '/bin',
      '/sbin',
      '/usr/bin',
      '/usr/sbin'
    ]
  }

  exec { 'drush.autocomplete.source':
    command  => 'bash -c "source /etc/bash_completion.d/drush.complete.sh"',
    provider => shell,
    onlyif   => 'which bash',
    path     => [
      '/bin',
      '/sbin',
      '/usr/bin',
      '/usr/sbin'
    ],
    require  => Exec['drush.autocomplete.install'] 
  }

}
