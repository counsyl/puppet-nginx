# == Define: nginx::site
#
# Configures a site for the Nginx web server.
#
# === Parameters
#
# [*ensure*]
#  Ensure value for the site, defaults to 'present'.
#
# [*content*]
#  The content to use for the site configuration file, mutually exclusive with
#  the `source` and `template` parameters.
#
# [*source*]
#  The Puppet file source for the site configuration file, mutually exclusive
#  with the `content` and `template` parameters.
#
# [*template*]
#  The template to render for the site configuration file content, mutually
#  exclusive with the `content` and `source` parameters.
#
define nginx::site(
  $ensure   = 'present',
  $content  = undef,
  $source   = undef,
  $template = undef,
) {
  include nginx

  # Locations of the site file and where it's enabled.
  $site = "${nginx::sites_available}/${name}"
  $enabled = "${nginx::sites_enabled}/${name}"

  case $ensure {
    'enabled', 'present': {
      include sys

      # Validate parameters when the site is enabled.
      if ( ($content or $template) and $source) {
        fail("Cannot provide both content/template and a file source for the nginx site.\n")
      } elsif ( $content and $template) {
        fail("Cannot provide both content and a template for the nginx site.\n")
      } elsif (! $content and ! $source and ! $template) {
        fail("Must provide either, content, source, or a template parameter for the nginx site.\n")
      }

      # Render site content if template was provided.
      if $template {
        $site_content = template($template)
      } else {
        $site_content = $content
      }

      file { $site:
        ensure  => file,
        owner   => 'root',
        group   => $sys::root_group,
        mode    => '0644',
        content => $site_content,
        source  => $source,
        notify  => Service[$nginx::service],
        require => Package[$nginx::package],
      }

      file { $enabled:
        ensure  => link,
        target  => $site,
        notify  => Service[$nginx::service],
        require => Package[$nginx::package],
      }
    }
    'disabled', 'absent': {
      file { $enabled:
        ensure  => absent,
        notify  => Service[$nginx::service],
        require => Package[$nginx::package],
      }
    }
    default: {
      fail("Invalid ensure value for nginx::site.\n")
    }
  }
}
