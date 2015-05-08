# == Class: gitolite
#
# Puppet class to setup gitolite after base config
# Called from gitolite::install
#
class gitolite::install::setup inherits ::gitolite::install {
  
  # install the binary packages for gitolite
  exec { "gitolite_install_binary":
    command     => "${root_dir}/gitolite/install -to ${root_dir}/bin",
    path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    user        => $user,
    cwd         => $root_dir,
    creates     => "${root_dir}/bin/gitolite",
    environment => "HOME=${root_dir}",
    require     => [
      Vcsrepo["${root_dir}/gitolite"],
      File["${root_dir}/.gitolite.rc"]
    ]
  }

  # setup the repositories directory
  file { "${root_dir}/repositories":
    ensure  => 'directory',
    mode    => '0755',
    owner   => $user,
    group   => $group,
    require => Exec['gitolite_install_binary']
  }

  # setup gitolite
  exec { "gitolite_install_setup":
    command     => "${root_dir}/bin/gitolite setup -a dummy",
    path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    user        => $user,
    cwd         => $root_dir,
    creates     => "${root_dir}/projects.list",
    environment => "HOME=${root_dir}",
    require     => File["${root_dir}/repositories"]
  }

  # purge the gitolite-admin.git repo since
  # we will be using puppet to control gitolite
  exec { 'gitolite_purge_configs':
    command => "rm -rf ${root_dir}/repositories/gitolite-admin.git",
    path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    user    => $user,
    cwd     => "${root_dir}",
    onlyif  => "ls ${root_dir}/repositories/gitolite-admin.git",
    require => Exec['gitolite_install_setup']
  }

  # ensure that the authorized_keys file is present
  # for the gitolite user
  file { "${root_dir}/.ssh/authorized_keys":
    ensure  => 'file',
    mode    => '0700',
    owner   => $user,
    group   => $group
  }
}