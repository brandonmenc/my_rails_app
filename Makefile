service = web
app_name = my_rails_app

docker_compose = docker-compose -f docker-compose.yml
make_this_in_docker = $(docker_compose) exec $(service) make _$@

#
# Top-level tasks
#

.PHONY: all
all:
	$(MAKE) build
	$(MAKE) bundle-install
	$(MAKE) yarn-install
	$(MAKE) up
	$(MAKE) db-create
	$(MAKE) db-migrate

.PHONY: nuke
nuke:
	$(MAKE) down
	$(MAKE) clean

#
# docker-compose
#

.PHONY: up
up:
	$(docker_compose) up -d

.PHONY: down
down:
	$(docker_compose) down

.PHONY: build
build:
	docker-compose build $(service)

.PHONY: restart-service
restart-service:
	$(docker_compose) restart $(service)

#
# Cleaning
#

.PHONY: clean
clean:
	$(MAKE) clean-volumes
	$(MAKE) clean-images

.PHONY: clean-volumes
clean-volumes:
	-docker volume rm $(shell docker volume ls -q | grep $(app_name)_)

.PHONY: clean-db-volume
clean-db-volume:
	-docker volume rm $(app_name)_db

.PHONY: clean-redis-volume
clean-redis-volume:
	-docker volume rm $(app_name)_redis

.PHONY: clean-images
clean-images:
	-docker image rm $(app_name)_$(service)

#
# Assets and Gems
#

.PHONY: yarn-install
yarn-install:
	$(docker_compose) run --rm $(service) yarn install

.PHONY: bundle-install
	$(docker_compose)  run --rm $(service) bundle install

#
# Database
#

.PHONY: db-create _db-create
db-create:
	$(make_this_in_docker)
_db-create:
	bin/rails db:create

.PHONY: db-drop _db-drop
db-drop:
	$(make_this_in_docker)
_db-drop:
	bin/rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1

.PHONY: db-migrate _db-migrate
db-migrate:
	$(make_this_in_docker)
_db-migrate:
	bin/rails db:migrate

.PHONY: db-seed _db-seed
db-seed:
	$(make_this_in_docker)
_db-seed:
	bin/rails db:seed

.PHONY: db-prepare _db-prepare
db-prepare:
	$(make_this_in_docker)
_db-prepare:
	bin/rails db:prepare

#
# Other tasks
#

.PHONY: console
console:
	$(docker_compose) exec $(service) bin/rails console

.PHONY: login
login:
	$(docker_compose) exec $(service) bash
