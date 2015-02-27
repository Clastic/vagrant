Clastic vagrant
===============

This box can be used for Clastic development.

Installation
------------

```
$ vagrant up
$ vagrant package
$ vagrant box add --name clastic-dev package.box
```

What's inside
-------------

This box contains the following:

 - php5-fpm
 - nginx
 - mysql
  - username: clastic
  - password: `null`
  - database: clastic_dev
 - npm
 - gulp
 - bower

