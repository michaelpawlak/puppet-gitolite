# == Class: gitolite::config::ssh
#
# Puppet class to configure ssh client aspects of gitolite
# Called from gitolite::config
#
class gitolite::config::ssh inherits ::gitolite::config {
  # configure ssh if desired
  if $manage_ssh {
    File {
      ensure  => 'file',
      mode    => '0600',
      owner   => $user,
      group   => $group
    }

    # itterate over the ssl_conf_hash variable if it is present
    if $ssh_conf_hash {
      each($ssh_conf_hash) |$ssh_host, $ssh_hash_values| {

        # assign a variable for the key_name
        $ssh_key_name = $ssh_hash_values['key_name']

        # determine the proper puppet file resource to setup
        # for the ssh keys (IE. template, content or source)
        if $ssh_hash_values['key_content'] {
          $ssh_key_content = $ssh_hash_values['key_content']
          file { "${root_dir}/.ssh/${ssh_key_name}":
            content => $ssh_key_content
          }  
        }
        elsif $ssh_hash_values['key_template'] {
          $ssh_key_template = $ssh_hash_values['key_template']
          file { "${root_dir}/.ssh/${ssh_key_name}":
            content => template($ssh_key_template)
          }
        }
        elsif $ssh_hash_values['key_source'] {
          $ssh_key_source = $ssh_hash_values['key_source']
          file { "${root_dir}/.ssh/${ssh_key_name}":
            source  => $ssh_key_source
          }
        }
      }

      # Setup the ssh client config file
      file { "${root_dir}/.ssh/config":
        content => template('gitolite/ssh_config.erb')
      }
    }
  }
}