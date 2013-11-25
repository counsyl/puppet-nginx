# == Class: nginx:params
#
# This class is for platform-dependent parameters used by Nginx.
#
class nginx::params {
  case $::osfamily {
    'debian': {
      $package = 'nginx-full'
      $config_root = '/etc/nginx'
      $config_dir = "${config_root}/conf.d"
      $config_file = "${config_root}/nginx.conf"
      $logs = '/var/log/nginx'
      $mime_types = "${config_root}/mime.types"
      $pid = '/var/run/nginx.pid'
      $service = 'nginx'
      $sites_available = "${config_root}/sites-available"
      $sites_enabled = "${config_root}/sites-enabled"

      # User and group that Nginx runs under on Debian platforms.
      $user = 'www-data'
      $uid = '33'
      $group = $user
      $gid = $uid
    }
    default: {
      fail("Do not know how to install nginx on ${::osfamily}.\n")
    }
  }
}
