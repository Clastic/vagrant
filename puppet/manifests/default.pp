
##############################################
# Includes
##############################################

include apt
include php
include php::pear
include php::composer
include nodejs

##############################################
# Resolve order
##############################################

Apt::Ppa <| |>
  -> Php::Extension <| |>
  -> Php::Config <| |>
  ~> Service["nginx"]

Apt::Source <| |> -> Package <| |>

##############################################
# PHP
##############################################

apt::ppa { 'ppa:ondrej/php5-5.6': }
apt::key { "ondrej":
  key => "E5267A6C"
}


class {
  ['php::dev', 'php::fpm', 'php::cli']:
    ensure => "installed";

  [
    'php::extension::curl', 'php::extension::gd', 'php::extension::imagick', 'php::extension::mcrypt',
    'php::extension::mysql', 'php::extension::redis', 'php::extension::apcu', 'php::extension::igbinary',
    'php::extension::xdebug'
  ]:
    ensure => "installed";
}

php::config { 'php-fpm-clastic':
  file    => '/etc/php5/fpm/conf.d/99-clastic.ini',
  config  => [
    'set xdebug/xdebug.max_nesting_level 500',
    'set xdebug/xdebug.remote_enable on',
    'set xdebug/xdebug.remote_connect_back on',
    'set xdebug/xdebug.idekey "vagrant"'
  ]
}


##############################################
# nginx
##############################################

package { 'nginx':
  ensure => "installed",
}
service { 'nginx':
  ensure  => 'running',
  require => Package['nginx'],
}

file { "nginx-config":
  path    => "/etc/nginx/sites-enabled/default",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('/vagrant/puppet/templates/site.conf.erb'),
  notify  => Service['nginx']
}

##############################################
# node & npm
##############################################

package { 'npm':
  ensure  => present,
  require => Anchor['nodejs::repo']
}
file { '/usr/bin/node':
  ensure  => 'link',
  target  => '/usr/bin/nodejs',
  require => Package['npm'],
}

package { 'gulp':
  ensure   => present,
  provider => 'npm',
  require  => Package['npm'],
}
package { 'bower':
  ensure   => present,
  provider => 'npm',
  require  => Package['npm'],
}

##############################################
# mysql
##############################################

class { '::mysql::server':
  root_password    => 'vagrant',
  override_options => {
    'mysqld' => {
      'bind-address' => '0.0.0.0'
    }
  }
}
mysql_user { 'clastic@%/*.*':
  ensure                   => 'present',
  max_connections_per_hour => '0',
  max_queries_per_hour     => '0',
  max_updates_per_hour     => '0',
  max_user_connections     => '0',
}

mysql_database { 'clastic_dev':
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_general_ci',
}

mysql_grant { 'clastic@%/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'clastic@%',
}
