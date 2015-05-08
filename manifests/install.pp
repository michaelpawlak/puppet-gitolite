# == Class: gitolite::install
#
# Puppet class to install gitolite
# Called from gitolite
#
class gitolite::install inherits ::gitolite {
  # install dependencies
  ensure_packages($dependencies)

  # create gitolite group
  group { "${group}":
    ensure  => 'present'
  }

  # create the gitolite user
  user { "${user}":
    ensure    => 'present',
    home      => $root_dir,
    shell     => $user_shell,
    gid       => $group,
    password  => '*',
    system    => true,
    require   => Group["${group}"],
    comment   => 'Gitolite User'
  }

  # create the gitolite root dir
  file { "${root_dir}":
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => User[$user]
  }

  # create the gitolite bin dir
  file { "${root_dir}/bin":
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => File["${root_dir}"],
    notify  => Vcsrepo["${root_dir}/gitolite"]
  }

  # create the gitolite user .ssh dir
  file { "${root_dir}/.ssh":
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0700'
  }

  # delete the bash_history file as a security precaution
  file { "${root_dir}/.bash_history":
    ensure  => 'absent'
  }

  # include all of the necessary gitolite sub classes
  include gitolite::install::repo
  include gitolite::install::rc
  include gitolite::install::setup
}