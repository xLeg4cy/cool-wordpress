FROM wordpress:cli

COPY ../../config/custom.ini /usr/local/etc/php/conf.d/custom.ini

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
