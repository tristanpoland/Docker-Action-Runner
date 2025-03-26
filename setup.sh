#!/bin/bash

# Download the latest runner
RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//')
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract the runner
tar xzf ./actions-runner-linux-x64.tar.gz
rm actions-runner-linux-x64.tar.gz

# Get a registration token
TOKEN=$(curl -s -XPOST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${GITHUB_ORG}/actions/runners/registration-token | jq -r .token)

# Configure the runner
./config.sh --url https://github.com/${GITHUB_ORG} --token ${TOKEN} --name $(hostname) --unattended --ephemeral

# Start the runner
./run.sh