include make.env 
export $(shell sed 's/=.*//' make.env)

.PHONY: help
.DEFAULT_GOAL := help

# Uppercase vars for internal use.
UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')
LOG_ERROR = @printf "\n>> \e[0;31m$1\e[0;00m\n\n"
LOG_WARN = @printf "\n>> \e[0;33m$1\e[0;00m\n\n"
LOG_INFO = @printf "\n>> \e[0;34m$1\e[0;00m\n\n"
LOG_SUCCESS = @printf "\n>> \e[0;36m$1\e[0;00m\n\n"
LOG_SUBLINE = @printf "   \e[0;34m$1\e[0;00m\n\n"

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'


build: ## Docker: build & tag
	$(call LOG_INFO,Building fresh Docker image)
	ledo image build

up: ## Docker: start compose stack
	$(call LOG_INFO,Up (daemon))
	ledo container up

stop: ## Docker: stop compose stack
	$(call LOG_INFO,Stop docker stack)
	ledo container stop

ps: ## Docker: show containers
	$(call LOG_INFO, Docker containers)
	ledo container ps

logs: ## Docker: show container's logs
	ledo container logs apiserver

shell: ## Shell main docker service
	$(call LOG_INFO, Shell)
	ledo container shell

clear: ## Clear cache
	$(call LOG_INFO,Clear system cache)
	ledo container exec  bin/console c:cl
	ledo container exec  bin/console c:w

mig-gen: ## Generate database migrations
	$(call LOG_INFO,Generate database migrations)
	ledo container exec  bin/console doctrine:migrations:diff

mig-run: ## Generate database migrations
	$(call LOG_INFO,Run database migrations)
	ledo container exec  bin/console d:m:m -n

mig-stat: ## Statistics of database migrations
	$(call LOG_INFO,Migrations status)
	ledo container exec  bin/console d:m:status

