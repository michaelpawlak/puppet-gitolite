# == Class: gitolite::config::users
#
# Puppet class to configure users for gitolite
# Called from gitolite::config
#
class gitolite::config::users inherits ::gitolite::config {
  
  # only config users if the hash is present
  if $user_conf_hash {

    # itterate over the user_conf_hash to configure users
    each($user_conf_hash) |$user_name, $user_values| {

      # determine the proper file resource to setup for
      # the user public keys (IE. template, content, source)
      if $user_values['content'] {
        file { "${root_dir}/.gitolite/keydir/${user_name}.pub":
          ensure  => 'file',
          mode    => '0644',
          owner   => $user,
          group   => $group,
          content => $user_values['content'],
          require => [
            Exec['gitolite_install_setup'],
            File["${root_dir}/.gitolite/keydir"]
          ],
          notify  => Exec['gitolite_compile']
        }
      }
      elsif $user_values['template'] {
        file { "${root_dir}/.gitolite/keydir/${user_name}.pub":
          ensure  => 'file',
          mode    => '0644',
          owner   => $user,
          group   => $group,
          content => template($user_values['template']),
          require => [
            Exec['gitolite_install_setup'],
            File["${root_dir}/.gitolite/keydir"]
          ],
          notify  => Exec['gitolite_compile']
        }
      }
      elsif $user_values['source'] {
        file { "${root_dir}/.gitolite/keydir/${user_name}.pub":
          ensure  => 'file',
          mode    => '0644',
          owner   => $user,
          group   => $group,
          source  => $user_values['source'],
          require => [
            Exec['gitolite_install_setup'],
            File["${root_dir}/.gitolite/keydir"]
          ],
          notify  => Exec['gitolite_compile']
        }
      }

      # Fail if the hash is not of the proper format
      else {
        fail('Values of $user_conf_hash must be a hash consisting of a hash containing keys of either \'content\', \'template\' or \'source\'')
      }
    }
  }
}