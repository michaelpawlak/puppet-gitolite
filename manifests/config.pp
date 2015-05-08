# == Class: gitolite::config
#
# Puppet class to configure gitolite
# Called from gitolite
#
class gitolite::config inherits ::gitolite {
  
  # ensure that our configuration file is in place
  file { "${root_dir}/.gitolite/conf/gitolite.conf":
    ensure  => 'file',
    mode    => '0600',
    owner   => $user,
    group   => $group,
    content => template('gitolite/gitolite.conf.erb'),
    require => Exec['gitolite_install_setup'],
    notify  => Exec['gitolite_compile']
  }

  # setup a separate dir for repo configs
  file { "${root_dir}/.gitolite/conf/repos":
    ensure  => 'directory',
    mode    => '0750',
    owner   => $user,
    group   => $group,
    require => Exec['gitolite_install_setup']
  }

  # setup a separate dir to how ssh pub keys
  file { "${root_dir}/.gitolite/keydir":
    ensure  => 'directory',
    mode    => '0750',
    owner   => $user,
    group   => $group,
    require => Exec['gitolite_install_setup']
  }

  # include subclasses for configuration
  include gitolite::config::groups
  include gitolite::config::repos
  include gitolite::config::users
  include gitolite::config::ssh
  include gitolite::config::compile
}