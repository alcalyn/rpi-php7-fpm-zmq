FROM shaula/rpi-php7-fpm

# install zmq and php-zmq
RUN apt-get update \
 && apt-get install build-essential libtool autoconf uuid-dev pkg-config git libsodium-dev wget bzip2

RUN wget https://archive.org/download/zeromq_4.1.4/zeromq-4.1.4.tar.gz \
 && tar -xvzf zeromq-4.1.4.tar.gz \
 && cd zeromq-4.1.4 \
 && ./configure \
 && make \
 && sudo make install \
 && sudo ldconfig \
 && cd .. \
 && rm -fr zeromq-4.1.4.tar.gz zeromq-4.1.4/

RUN git clone git://github.com/mkoppanen/php-zmq.git \
 && cd php-zmq \
 && phpize && ./configure \
 && make \
 && make install \
 && cd .. \
 && rm -fr php-zmq

RUN echo "extension=zmq.so" > /usr/local/etc/php/conf.d/docker-php-ext-zmq.ini

RUN apt-get remove git build-essential \
 && apt-get autoremove --purge \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
