.PHONY: up down init test smoke plans layout clean

up:
	docker compose up --detach db

down:
	docker compose down --remove-orphans

init:
	bash scripts/init.sh

test:
	bash scripts/test.sh

smoke:
	bash scripts/smoke-test.sh

plans:
	bash scripts/capture-plans.sh

layout:
	bash scripts/check-layout.sh

clean:
	docker compose down --volumes --remove-orphans
