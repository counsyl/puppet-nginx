# == Class: nginx::config
#
# Sets up Nginx's main configuration file according to the given parameters.
#
# === Parameters
#
# [*content*]
#  The content to use for the configuration file, mutually exclusive with the
#  `source` and `template` parameters.
#
# [*source*]
#  The Puppet file source for the configuration file, mutually exclusive with
#  the `content` and `template` parameters.
#
# [*template*]
#  The template to render for the configuration file content, mutually
#  exclusive with the `content` and `source` parameters.
#
# [*config_file*]
#  The path to the main Nginx configuration file, the default depends on the
#  platform, e.g., '/etc/nginx/nginx.conf' on Debian systems.
#
class nginx::config(
  $content     = undef,
  $source      = undef,
  $template    = undef,
  $config_file = $nginx::params::config_file,
) inherits nginx::params {
  include nginx
  include sys

  if ( ($content or $template) and $source) {
    fail("Cannot provide both content/template and a file source for the nginx configuration file.\n")
  } elsif ( $content and $template) {
    fail("Cannot provide both content and a template for the nginx configuration file.\n")
  } elsif (! $content and ! $source and ! $template) {
    fail("Must provide either, content, source, or a template parameter for the nginx configuration file.\n")
  }

  # Render content if template was provided.
  if $template {
    $config_content = template($template)
  } else {
    $config_content = $content
  }

  # File resource for the main nginx configuration file.
  file { $config_file:
    ensure  => file,
    owner   => 'root',
    group   => $sys::root_group,
    mode    => '0644',
    content => $config_content,
    source  => $source,
    notify  => Service[$nginx::service],
    require => Package[$nginx::package],
  }
}
