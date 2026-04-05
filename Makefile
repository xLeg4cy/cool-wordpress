args ?=

install:
	@composer install --prefer-dist
	@bun install
.PHONY: install

update:
	@composer update
.PHONY: update

up:
	@docker compose up --remove-orphans
.PHONY: up

down:
	@docker compose down
.PHONY: down

destroy:
	@docker compose down -v
.PHONY: destroy

env:
	@docker compose exec wordpress $(args)
.PHONY: env

shell:
	@docker compose exec -it wordpress bash
.PHONY: shell

cli:
	@docker compose run --rm wordpress-cli -- $(args)
.PHONY: cli
