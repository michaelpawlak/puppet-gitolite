# == Class: gitolite::config::groups
#
# Puppet class to configure groups for use with gitolite
# Called from gitolite::config
#
class gitolite::config::groups inherits ::gitolite::config {
  
  # setup the groups.conf file in the conf dir
  if $group_conf_hash {
    file { "${root_dir}/.gitolite/conf/groups.conf":
      ensure  => 'file',
      owner   => $user,
      group   => $group,
      mode    => '0644',
      content => template('gitolite/group.conf.erb'),
      require => Exec['gitolite_install_setup'],
      notify  => Exec['gitolite_compile']
    }
  }
}