FROM wordpress:cli

COPY --from=config custom.ini /usr/local/etc/php/conf.d/custom.ini

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
