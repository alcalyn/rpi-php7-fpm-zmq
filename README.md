PHP7 and ZMQ Docker image for Raspberry Pi
==========================================

Docker image containing PHP7-fpm,
and have ZMQ and php-zmq extension installed to use ZeroMQ.

It is based on `resin/rpi-raspbian` and
[shaula/rpi-php7-fpm](https://github.com/shaula/rpi-php7-fpm).

See the image on DockerHub: https://hub.docker.com/r/alcalyn/rpi-php7-fpm-zmq/


## Usage


### Pulling the image

``` bash
docker pull alcalyn/rpi-php7-fpm-zmq
```

### Using it in a Dockerfile

```
FROM alcalyn/rpi-php7-fpm-zmq
```

### Adding PHP extensions (based on [shaula/rpi-php7-fpm](https://github.com/shaula/rpi-php7-fpm#usage))

```
FROM alcalyn/rpi-php7-fpm-zmq

# install PHP extensions & PECL modules with dependencies
RUN apt-get update \
 && apt-get install -y bzip2 git vim wget \
        libxslt1.1 libxslt1-dev \
        libicu-dev \
        libmcrypt-dev \
        libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install gd \
 && docker-php-ext-install intl \
 && docker-php-ext-install mcrypt \
 && docker-php-ext-install opcache \
 && docker-php-ext-install pdo_mysql mysqli \
 && docker-php-ext-install xsl \
 && docker-php-ext-install zip \
 && pecl install redis && docker-php-ext-enable redis
```

> **Note**: ZMQ and `php-zmq` extension
> are already installed.

See all available PHP extensions here: https://github.com/shaula/rpi-php7-fpm#php-extensions


### Adding composer

```
FROM alcalyn/rpi-php7-fpm-zmq

# composer requires zip and git
RUN apt-get update \
 && apt-get install -y \
        bzip2 git wget \
        zlib1g-dev \
        libicu-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN docker-php-ext-install intl \
 && docker-php-ext-install zip

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
 && php composer-setup.php --filename=composer \
 && php -r "unlink('composer-setup.php');" \
 && mv composer /usr/local/bin/composer
```

Then you can use Composer globally with `composer install`.


## License

This library is under [MIT License](LICENSE).
