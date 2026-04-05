install:
	@composer install --prefer-dist
	@bun install
.PHONY: install

update:
	@composer update
.PHONY: update

up:
	@docker compose up
.PHONY: up

down:
	@docker compose down
.PHONY: down

destroy:
	@docker compose down -v
.PHONY: destroy
