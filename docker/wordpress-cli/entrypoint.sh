#!/bin/bash
# Wait for Database
until printf '\n' | nc db 3306 >/dev/null 2>&1; do
	echo "Waiting for DB..."
	sleep 1
done
# Wait for wp-config.php
until [ -f wp-config.php ]; do
	echo "Waiting for wp-config.php..."
	sleep 1
done
# Check if wp-settings.php exists; if not, download core files
if [ ! -f wp-settings.php ]; then
	echo "WordPress files not found. Downloading..."
	wp core download
fi
# Now check if it needs installation
if ! wp core is-installed; then
	echo "Installing WordPress..."
	wp core install \
		--url="http://localhost:80" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_USER}" \
		--admin_password="${WP_PASSWORD}" \
		--admin_email="${WP_EMAIL}" \
		--skip-plugins
fi
# Optional: execute passed arguments
if [ $# -gt 0 ]; then
	wp "$@"
	exit $?
fi
# Keep container alive for interactive exec sessions
tail -f /dev/null
