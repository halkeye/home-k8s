# Define a variable for the shell to use 'printf' correctly
SHELL := /bin/bash
CLUSTER ?= home-k8s
NAMESPACE ?= $(shell grep namespace: kustomization.yaml | awk '{print $$2}')

# Server-side apply with force conflicts (set to enable, e.g., --force-conflicts --server-side=true)
KUBECTL_SERVER_SIDE ?=

# Define the help target as PHONY, meaning it's not a file
.PHONY: help diff all

help: ## Display this help message
	@printf "Usage:\n  make <target>\n\nTargets:\n"
	@grep -E '^[a-zA-Z0-9 -]+:.*##'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 3- -d'#')\n"; done

all: diff ## Default target to diff everything

diff: ## Show difference between local and dev
	$(MAKE) -s build | kubectl diff --context $(CLUSTER) $(KUBECTL_SERVER_SIDE) -f -

apply: ## Apply
	$(MAKE) -s build | kubectl apply --context $(CLUSTER) $(KUBECTL_SERVER_SIDE) -f -

build: ## Build
	kustomize build --load-restrictor LoadRestrictionsNone --helm-api-versions monitoring.coreos.com/v1 --helm-api-versions gateway.networking.k8s.io/v1/HTTPRoute --enable-helm .

.PHONY: logs
logs: ## Logs
	stern --context $(CLUSTER) -n $(NAMESPACE) .
