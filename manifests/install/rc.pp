# == Class: gitolite::install::rc
#
# Puppet class to setup rc file for install of gitolite
# Called from gitolite::install
#
class gitolite::install::rc inherits ::gitolite::install {
  
  # create the .gitolite.rc file
  file { "${root_dir}/.gitolite.rc":
    ensure  => 'file',
    mode    => '0600',
    owner   => $user,
    group   => $group,
    content => template('gitolite/gitolite.rc.erb'),
    notify  => Exec['gitolite_install_binary'],
    require => File["${root_dir}"]
  }
}