FROM wordpress:latest

ARG WP_CLI_VERSION=2.11.0

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends unzip less default-mysql-client; \
    rm -rf /var/lib/apt/lists/*; \
    curl -fsSL -o /tmp/wp-cli.phar "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar"; \
    curl -fsSL -o /tmp/wp-cli.phar.sha512 "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar.sha512"; \
    echo "$(awk '{print $1}' /tmp/wp-cli.phar.sha512)  /tmp/wp-cli.phar" | sha512sum -c -; \
    install -m 0755 /tmp/wp-cli.phar /usr/local/bin/wp; \
    rm -f /tmp/wp-cli.phar /tmp/wp-cli.phar.sha512; \
    wp --allow-root --version

RUN set -eux; \
    wp --allow-root plugin install masteriyo redis-cache --path=/usr/src/wordpress; \
    chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins/masteriyo /usr/src/wordpress/wp-content/plugins/redis-cache

COPY php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY plugins/ /usr/src/wordpress/wp-content/plugins/

RUN set -eux; \
    plugin_root=/usr/src/wordpress/wp-content/plugins; \
    for archive in "$plugin_root"/*.zip; do \
      [ -e "$archive" ] || continue; \
      top_dirs="$(zipinfo -1 "$archive" | awk -F/ 'NF > 1 && $1 != "" { print $1 }' | sort -u)"; \
      for dir in $top_dirs; do \
        if [ -e "$plugin_root/$dir" ]; then \
          echo "Plugin archive $archive would overwrite existing plugin directory $plugin_root/$dir" >&2; \
          exit 1; \
        fi; \
      done; \
      unzip -q "$archive" -d "$plugin_root"; \
      rm -f "$archive"; \
    done; \
    rm -f "$plugin_root/.gitkeep"; \
    chown -R www-data:www-data "$plugin_root"
