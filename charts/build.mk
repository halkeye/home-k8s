# Define a variable for the shell to use 'printf' correctly
SHELL := /bin/bash
CLUSTER ?= home-k8s

# Define the help target as PHONY, meaning it's not a file
.PHONY: help diff all

help: ## Display this help message
	@printf "Usage:\n  make <target>\n\nTargets:\n"
	@grep -E '^[a-zA-Z0-9 -]+:.*##'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 3- -d'#')\n"; done

all: diff ## Default target to diff everything

diff: ## Show difference between local and dev
	kustomize build --helm-api-versions monitoring.coreos.com/v1 --enable-helm . | kubectl diff --context $(CLUSTER) -f -

apply: ## Apply
	kustomize build --helm-api-versions monitoring.coreos.com/v1 --enable-helm . | kubectl apply --context $(CLUSTER) -f -

build: ## Build
	kustomize build --helm-api-versions monitoring.coreos.com/v1 --enable-helm . --context $(CLUSTER)
