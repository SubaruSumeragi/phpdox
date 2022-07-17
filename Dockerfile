# Set defaults

FROM php:7.4-bullseye as build
RUN apt-get update -y ;\
    apt-get install -y  libxslt1-dev \
        git \
        zip ;\
    docker-php-ext-install -j$(nproc) xsl
RUN apt-get install -y git

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
# RUN COMPOSER_HOME="/composer" composer global require --prefer-dist --no-progress --dev theseer/phpdox${PACKAGIST_NAME}:${VERSION}
# ENV PATH /composer/vendor/bin:${PATH}

COPY . /opt/phpdox
WORKDIR /opt/phpdox
RUN composer install 

ENV PATH /opt/phpdox:${PATH}
# Add entrypoint script

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Add image labels

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.docker.cmd="docker run --rm --volume \${PWD}:/app --workdir /app ${IMAGE_NAME}"

# Package container

WORKDIR "/app"
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/opt/phpdox/phpdox"]