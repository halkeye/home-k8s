#!make
SHELL = /bin/bash
.DEFAULT_GOAL := site

ANSIBLE_PLAYBOOK ?= $(VENV)/ansible-playbook
ANSIBLE_DEBUG :=
PLAYBOOK :=

.PHONY: pull
pull: .gitmodules ## get all dependencies
	git pull
	git submodule update --init

.PHONY: push
push: ## git push
	git push -u

.PHONY: clean
clean: clean-venv ## Delete all generated artefacts
	find . -name "*.pyc" -exec $(RM) -rf {} \;

.PHONY: setup
setup: venv ## Installs minimal dependencies
	(which unzip || sudo apt install -y unzip) && \
	(which zip || sudo apt install -y zip)

.PHONY: sync
sync: ## Synchronize ansible data
	git pull --rebase

.PHONY: run
run: setup ## Run
	@if [ "$(PLAYBOOK)" = "" ]; then\
		echo "Playbook not set";\
		exit 1;\
	fi
	$(ANSIBLE_PLAYBOOK) $(PLAYBOOK).yml $(ANSIBLE_DEBUG)

.PHONY: lint
lint: setup ## Perform an ansible-lint linting
	$(VENV)/ansible-lint main.yml

.PHONY: vars
vars: setup ## List all variables
	$(VENV)/ansible -b -m ansible.builtin.setup $${ANSIBLE_HOST:-all}

.PHONY: debug
debug: ANSIBLE_DEBUG+=-vvv
debug: run ## Run in debug mode

.PHONY: site
site: PLAYBOOK+=site
site: run ## Just update site

.PHONY: packages
packages: PLAYBOOK+=packages
packages: run ## Just update packages

.PHONY: reboot
reboot: PLAYBOOK+=reboot
reboot: run ## Just reboot

.PHONY: reset
reset: PLAYBOOK+=reset
reset: run ## Reset all the things

.PHONY: diff
diff: PLAYBOOK+=site
diff: ANSIBLE_DEBUG+=--check --diff
diff: run ## Dry run and output diffs not run

.PHONY: check
check: diff

.PHONY: olm
olm:
	operator-sdk olm install --version=v0.28.0

.PHONY: help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2023.04.17/Makefile.venv"
	echo "fb48375ed1fd19e41e0cdcf51a4a0c6d1010dfe03b672ffc4c26a91878544f82 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv

