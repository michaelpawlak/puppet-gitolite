class gitolite::params {
  case $::osfamily {
    'RedHat': {
      $dependencies = ['git', 'perl-Error', 'perl-Git']
      $package      = ['gitolite']
    }
    'Debian': {
      $dependencies = ['git']
      $package      = ['gitolite']
    }
    default: {
      fail('Currently only support RHEL and Debian based distros')
    }
  }
}