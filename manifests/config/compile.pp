# == Class: gitolite::config::compile
#
# Puppet class to apply all config changes to gitolite
# Called from gitolite::config
#
class gitolite::config::compile inherits ::gitolite::config {
  
  # execute the compile job to apply configs
  exec { 'gitolite_compile':
    command     => "${root_dir}/bin/gitolite compile",
    path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    user        => $user,
    cwd         => "${root_dir}",
    environment => "HOME=${root_dir}",
    notify      => Exec['gitolite_trigger']
  }

  # execute the POST_COMPILE job after compilation
  exec { 'gitolite_trigger':
    command     => "${root_dir}/bin/gitolite trigger POST_COMPILE",
    path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    user        => $user,
    environment => "HOME=${root_dir}",
    cwd         => "${root_dir}"
  }
}