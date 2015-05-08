
# == Class: gitolite
#
# Puppet class to install and configure gitolite
# Called from gitolite::install
#
class gitolite::install::repo inherits ::gitolite::install {

  # create the gitolite git repo
  vcsrepo { "${root_dir}/gitolite":
    ensure    => 'latest',
    provider  => git,
    source    => $repo_source,
    owner     => $user,
    group     => $group,
    revision  => 'master',
    require   => File["${root_dir}"]
  }
}