nginx
=====

This Puppet module is for installing and configuring the Nginx webserver.
To install Nginx and start its service, you'd simply add the following
to your manifest:

```puppet
include nginx
```

To provide the content of the main configuration file, the `nginx::config`
class may be used:

```puppet
class { 'nginx::config':
   source => 'puppet:///modules/counsyl/nginx/nginx.conf',
}
```
