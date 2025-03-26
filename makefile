# Makefile for building the Docker image for GitHub Runner

# Variables
IMAGE_NAME := github-runner
GITHUB_ORG := <YOUR-GITHUB-ORGANIZATION>
ACCESS_TOKEN := <YOUR-GITHUB-ACCESS-TOKEN>

# Default target
.PHONY: build
build:
	docker build --tag $(IMAGE_NAME) \
		--build-arg GITHUB_ORG=$(GITHUB_ORG) \
		--build-arg ACCESS_TOKEN=$(ACCESS_TOKEN) .