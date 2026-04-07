#!/bin/bash

get_commands() {
	sed -En 's/^([[:alnum:]]+)\).*/\1/p' "$0" | paste -sd, -
}

# Check if a command was provided
if [ -z "$1" ]; then
	echo "Usage: $0 {$(get_commands)} [args...]"
	exit 1
fi

COMMAND=$1
shift

case "$COMMAND" in
install)
	composer install --prefer-dist
	bun install
	;;
update)
	composer update
	;;
up)
	docker compose up --remove-orphans
	;;
down)
	docker compose down
	;;
destroy)
	docker compose down -v
	;;
env)
	# Passes all remaining arguments to exec
	docker compose exec wordpress "$@"
	;;
shell)
	docker compose exec -it wordpress bash
	;;
cli)
	docker compose run --rm wordpress-cli -- "$@"
	;;
composer)
	docker compose exec -it wordpress composer "$@"
	;;
*)
	echo "Unknown command: $COMMAND"
	echo "Available commands: $(get_commands)"
	exit 1
	;;
esac
