# == Class: gitolite
#
# Puppet class to install and configure gitolite
#
class gitolite (
  ## Start General Settings ##
  $user                   = 'git',
  $group                  = 'git',
  $user_shell             = '/bin/bash',
  $root_dir               = '/var/lib/gitolite',
  ## End General Settings ##

  ## Start SSH Settings ##
  $manage_ssh             = false,
  $ssh_conf_hash          = undef,
  ## End SSH Settings ##

  ## Start Config Settings ##
  $repo_source            = 'git://github.com/sitaramc/gitolite',
  $group_conf_hash        = undef,
  $repo_conf_hash         = undef,
  $user_conf_hash         = undef,
  ## End Config Settings ##

  ## Start RC Config Settings ##
  $rc_umask               = '0077',
  $rc_git_config_keys     = '',
  $rc_log_extra           = '1',
  $rc_log_dest            = ['normal'],
  $rc_roles               = {
    'READERS' => '1',
    'WRITERS' => '1'
  },
  $rc_cache               = undef,
  $rc_site_info           = undef,
  $rc_display_cpu_time    = undef,
  $rc_cpu_time_warn_limit = undef,
  $rc_hostname            = undef,
  $rc_cache_ttl           = undef,
  $rc_local_code          = undef,
  $rc_enable_commands     = ['help', 'desc', 'info',
                             'perms', 'writable'],
  $rc_enable_features     = ['ssh-authkeys', 'git-config', 'daemon',
                             'gitweb']
  ## End RC Config Settings ##
  ) inherits ::gitolite::params {

  $root_dir_base = dirname($root_dir)

  # validate the general settings
  validate_string($user)
  validate_string($group)
  validate_absolute_path($user_shell)
  validate_string($pub_key)
  validate_absolute_path($root_dir_base)
  
  # validate ssh settings
  validate_bool($manage_ssh)
  if $ssh_conf_hash {
    validate_hash($ssh_conf_hash)
  }

  # validate config settings
  validate_string($repo_source)
  if $group_conf_hash {
    validate_hash($group_conf_hash)
  }
  if $repo_conf_hash {
    validate_hash($repo_conf_hash)
  }
  if $user_conf_hash {
    validate_hash($user_conf_hash)
  }

  # validate rc config settings
  validate_re($rc_umask, '^[0-7][0-7][0-7][0-7]$', '$rc_umask must be a valid umask')
  validate_string($rc_git_config_keys)
  validate_re($rc_log_extra, ['0', '1'])
  validate_array($rc_log_dest)
  validate_hash($rc_roles)
  if $rc_cache {
    validate_re($rc_cache, ['Redis'])
  }
  if $rc_site_info {
    validate_string($rc_site_info)
  }
  if $rc_display_cpu_time {
    validate_re($rc_display_cpu_time, ['0', '1'])
  }
  if $rc_cpu_time_warn_limit {
    validate_re($rc_cpu_time_warn_limit,
                '^([1-9]{0,1})([0-9]{1})(\.[0-9])?$',
                '$rc_cpu_time_warn_limit must be a float with 1 decimal place 0 =< 100')
  }
  if $rc_hostname {
    validate_string($rc_hostname)
  }
  if $rc_cache_ttl {
    validate_re($rc_cache_ttl, '^\d$', '$rc_cache_ttl must be an integer')
  }
  if $rc_local_code {
    validate_string($rc_local_code)
  }
  validate_array($rc_enable_commands)
  validate_array($rc_enable_features)

  # install the classes in order
  anchor { 'gitolite::begin': } ->
  class { 'gitolite::install': } ->
  class { 'gitolite::config': } ->
  anchor { 'gitolite::end': }
}