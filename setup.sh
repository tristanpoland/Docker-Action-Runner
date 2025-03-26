#!/bin/bash

set -e

# GitHub Actions Runner Registration Variables
RUNNER_NAME=${RUNNER_NAME:-$(hostname)}
RUNNER_LABELS=${RUNNER_LABELS:-"self-hosted,Linux,X64"}

# First check if we're running as root or with sudo
if [ "$(id -u)" = "0" ]; then
    echo "ERROR: This script must not be run as root or with sudo"
    exit 1
fi

# Check if the runner directory is empty
if [ ! -f "./config.sh" ]; then
    echo "Downloading GitHub Actions runner..."
    
    # Get the latest runner version
    LATEST_VERSION_LABEL=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')
    LATEST_VERSION=${LATEST_VERSION_LABEL:1} # remove the 'v' prefix
    
    # Download and extract the runner
    curl -o actions-runner-linux-x64-${LATEST_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/${LATEST_VERSION_LABEL}/actions-runner-linux-x64-${LATEST_VERSION}.tar.gz
    tar xzf ./actions-runner-linux-x64-${LATEST_VERSION}.tar.gz
    rm actions-runner-linux-x64-${LATEST_VERSION}.tar.gz
fi

# Configure the runner
CONFIG_ARGS=""

if [ -n "${GITHUB_ACCESS_TOKEN}" ]; then
    if [ -n "${GITHUB_REPOSITORY}" ]; then
        echo "Registering runner for repository: ${GITHUB_REPOSITORY}"
        RUNNER_TOKEN=$(curl -s -X POST -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/runners/registration-token" | jq -r '.token')
        CONFIG_ARGS="--url https://github.com/${GITHUB_REPOSITORY} --token ${RUNNER_TOKEN}"
    elif [ -n "${GITHUB_ORGANIZATION}" ]; then
        echo "Registering runner for organization: ${GITHUB_ORGANIZATION}"
        RUNNER_TOKEN=$(curl -s -X POST -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/${GITHUB_ORGANIZATION}/actions/runners/registration-token" | jq -r '.token')
        CONFIG_ARGS="--url https://github.com/${GITHUB_ORGANIZATION} --token ${RUNNER_TOKEN}"
    else
        echo "Error: You must provide either GITHUB_REPOSITORY or GITHUB_ORGANIZATION"
        exit 1
    fi
else
    echo "Error: GITHUB_ACCESS_TOKEN is required"
    exit 1
fi

# Configure the runner if it's not already configured
if [ ! -f "./.runner" ]; then
    ./config.sh --name "${RUNNER_NAME}" --labels "${RUNNER_LABELS}" ${CONFIG_ARGS} --unattended
fi

# Start the runner
./run.sh