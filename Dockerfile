# Set defaults

FROM php:7.4-bullseye as build
RUN apt-get update -y ;\
    apt-get install -y  libxslt1-dev \
        git \
        zip ;\
    docker-php-ext-install -j$(nproc) xsl
RUN apt-get install -y git

RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory_limit.ini

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
# RUN COMPOSER_HOME="/composer" composer global require --prefer-dist --no-progress --dev theseer/phpdox${PACKAGIST_NAME}:${VERSION}
# ENV PATH /composer/vendor/bin:${PATH}

COPY . /opt/phpdox
WORKDIR /opt/phpdox
RUN COMPOSER_ALLOW_SUPERUSER=1 \
    composer install 

ENV PATH /opt/phpdox:${PATH}
# Add image labels

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.docker.cmd="docker run --rm --volume \${PWD}:/app --workdir /app ${IMAGE_NAME}"

# Package container

WORKDIR "/app"
ENTRYPOINT ["php" , "/opt/phpdox/phpdox"]
CMD ["--help"]