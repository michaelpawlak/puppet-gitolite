# == Class: gitolite::config::repos
#
# Puppet class to configure repos for gitolite gitolite
#
class gitolite::config::repos inherits ::gitolite::config {
  
  # configure our repos
  if $repo_conf_hash {

    # itterate over the repo_conf_hash variable
    # to create our repo configs
    each($repo_conf_hash) |$repo_name, $repo_hash| {
      file { "${root_dir}/.gitolite/conf/repos/${repo_name}.conf":
        ensure  => 'file',
        mode    => '0644',
        owner   => $user,
        group   => $group,
        content => template('gitolite/repo.conf.erb'),
        require => [
          Exec['gitolite_install_setup'],
          Class['gitolite::config::ssh']
        ],
        notify  => [
          Exec["git_repo_${repo_name}"],
          Exec['gitolite_compile']
        ]
      }
      
      # assign a cariable for the repo source
      $repo_source = $repo_hash['source']

      # if the repo_source is present clone it
      if $repo_source {
        $repo_command = "git clone --bare ${repo_source} ${root_dir}/repositories/${repo_name}.git"
      }
      # if not we need to init the repo
      else {
        $repo_command = "git init --bare ${root_dir}/repositories/${repo_name}.git"
      }

      # execute the repo command based on the repo source
      exec { "git_repo_${repo_name}":
        command => $repo_command,
        path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        user    => $user,
        cwd     => $root_dir,
        creates => "${root_dir}/repositories/${repo_name}.git",
        notify  => Exec["chmod_${repo_name}.git"],
        require => Class['gitolite::config::ssh']
      }

      # setup the proper permissions on the repo
      exec { "chmod_${repo_name}.git":
        command => "chmod -R 0700 ${root_dir}/repositories/${repo_name}.git",
        path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        user    => $user,
        cwd     => $root_dir,
        notify  => Exec["chown_${repo_name}.git"]
      }

      # setup the proper ownership of the repo
      exec { "chown_${repo_name}.git":
        command => "chown -R ${user}.${group} ${root_dir}/repositories/${repo_name}.git",
        path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        user    => $user,
        cwd     => $root_dir
      }
    }
  }
}