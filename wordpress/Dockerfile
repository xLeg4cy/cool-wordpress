FROM wordpress:latest

ARG WP_CLI_VERSION=2.11.0

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends unzip less default-mysql-client; \
    rm -rf /var/lib/apt/lists/*; \
    curl -fsSL -o /usr/local/bin/wp "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar"; \
    chmod +x /usr/local/bin/wp; \
    wp --allow-root --version

RUN set -eux; \
    wp --allow-root plugin install masteriyo redis-cache --path=/usr/src/wordpress; \
    chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins/masteriyo /usr/src/wordpress/wp-content/plugins/redis-cache

COPY php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY plugins/ /usr/src/wordpress/wp-content/plugins/

RUN set -eux; \
    find /usr/src/wordpress/wp-content/plugins -maxdepth 1 -type f -name '*.zip' \
      -exec unzip -oq '{}' -d /usr/src/wordpress/wp-content/plugins/ ';' \
      -exec rm -f '{}' ';'; \
    rm -f /usr/src/wordpress/wp-content/plugins/.gitkeep; \
    chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins
