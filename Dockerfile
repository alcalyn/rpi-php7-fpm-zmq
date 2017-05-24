FROM shaula/rpi-php7-fpm

LABEL maintainer="Alcalyn"

# install zmq and php-zmq
RUN apt-get update \
 && apt-get install build-essential libtool autoconf uuid-dev pkg-config git libsodium-dev wget bzip2 \

 && wget https://archive.org/download/zeromq_4.1.4/zeromq-4.1.4.tar.gz \
 && tar -xvzf zeromq-4.1.4.tar.gz \
 && cd zeromq-4.1.4 \
 && ./configure \
 && make \
 && sudo make install \
 && sudo ldconfig \
 && cd .. \
 && rm -fr zeromq-4.1.4.tar.gz zeromq-4.1.4/ \

 && git clone git://github.com/mkoppanen/php-zmq.git \
 && cd php-zmq \
 && phpize && ./configure \
 && make \
 && make install \
 && cd .. \
 && rm -fr php-zmq \

 && echo "extension=zmq.so" > /usr/local/etc/php/conf.d/docker-php-ext-zmq.ini \

 && apt-get remove git build-essential \
 && apt-get autoremove --purge \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
