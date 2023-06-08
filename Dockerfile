FROM docker.io/composer:2.2.7 AS composer

FROM docker.io/php:8.2.0-fpm-bullseye

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
build-essential \
clang \
curl \
git \
libzip-dev \
zlib1g-dev \
zip \
libkeepalive0 \
libssl-dev \
libsasl2-dev \
sudo \
vim \
libpq-dev \
librdkafka-dev \
lsof \
libpng-dev \
strace \
unzip


RUN rm -rf /var/lib/apt/lists/*

RUN pecl install protobuf
RUN pecl install opentelemetry-beta


RUN docker-php-ext-enable \
    opentelemetry

RUN docker-php-ext-enable protobuf

WORKDIR /home/opentelemetry-bug

ENV OTEL_PHP_AUTOLOAD_ENABLED=true
ENV OTEL_TRACES_EXPORTER=otlp
ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://host.docker.internal:4318
ENV OTEL_EXPORTER_ZIPKIN_ENDPOINT=http://host.docker.internal:4318/api/v2/spans
ENV OTEL_PHP_TRACES_PROCESSOR=batch
ENV OTEL_SERVICE_NAME=opentelemetry-bug

COPY composer.json .
COPY composer.lock .
COPY bin .
COPY config .
COPY public .
COPY src .
COPY .env .
COPY symfony.lock .


RUN \
   composer install         \
     --ignore-platform-reqs \
     --prefer-dist          \
     --no-scripts           \
     --no-progress          \
     --no-interaction

CMD ["php-fpm"]

