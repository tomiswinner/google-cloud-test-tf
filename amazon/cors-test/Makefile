.PHONY: up up-no-cors down build logs

up:
	CORS_ENABLED=true docker compose up --build

up-no-cors:
	CORS_ENABLED=false docker compose up --build

down:
	docker compose down

build:
	docker compose build

logs:
	docker compose logs -f

