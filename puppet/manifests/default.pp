
include apt
include php

Apt::Ppa <| |>
  -> Php::Extension <| |>
  -> Php::Config <| |>
  ~> Service["nginx"]

Apt::Source <| |> -> Package <| |>


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

package { 'nginx':
  ensure => "installed",
}
service { 'nginx':
  ensure => 'running',
}

file { "nginx-config":
  path    => "/etc/nginx/sites-enabled/default",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('/vagrant/puppet/templates/site.conf.erb'),
  notify  => Service['nginx']
}
