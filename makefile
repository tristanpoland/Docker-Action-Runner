# Makefile for building the Docker image for GitHub Runner

# Variables
IMAGE_NAME := github-runner

# Default target
.PHONY: build
build:
	docker build --tag $(IMAGE_NAME) .

up: build
	docker-compose up -d