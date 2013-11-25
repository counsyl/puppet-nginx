# == Class: nginx
#
# Install the Nginx web server, and configures its service.
#
# == Parameters
#
# [*ensure*]
#  Ensure value for Nginx, defaults 'present'.
#
# [*package*]
#  The name of the Nginx package, default is platform-dependent, e.g.,
#  it's 'nginx-full' on Debian-based systems.
#
# [*version*]
#  The version of Nginx to install (the ensure value for the Nginx package
#  resource), default is 'installed'.
#
# [*service*]
#  The name of the Nginx service, default is platform-dependent, e.g.,
#  it's 'nginx' on Debian-based systems.
#
# [*service_enable*]
#  The enable parameter for the Nginx service resource, defaults to true.
#
# [*service_ensure*]
#  The ensure parameter for the Nginx service resource, defaults to 'running'.
#
class nginx(
  $ensure         = 'present',
  $package        = $nginx::params::package,
  $version        = undef,
  $service        = $nginx::params::service,
  $service_enable = true,
  $service_ensure = 'running',
) inherits nginx::params {
  # Determine the ensure value for the package.
  case $ensure {
    'present', 'installed': {
      if $version {
        $package_ensure = $version
      } else {
        $package_ensure = 'installed'
      }
    }
    'absent', 'uninstalled': {
      $package_ensure = 'absent'
    }
    default: {
      fail("Invalid ensure value for the nginx class.\n")
    }
  }

  package { $package:
    ensure => $package_ensure,
    alias  => 'nginx',
  }

  if ! ($ensure in ['absent', 'uninstalled']) {
    service { $service:
      ensure    => $service_ensure,
      alias     => 'nginx',
      enable    => $service_enable,
      subscribe => Package[$package],
    }
  }
}
