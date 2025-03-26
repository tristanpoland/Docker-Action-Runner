FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Set up work directory
WORKDIR /actions-runner

# Arguments that can be passed during build
ARG GITHUB_ORG
ARG ACCESS_TOKEN

# Environment variables
ENV GITHUB_ORG=${GITHUB_ORG}
ENV ACCESS_TOKEN=${ACCESS_TOKEN}

# Copy the runner setup script
COPY setup.sh .
RUN chmod +x setup.sh

# Start the runner
ENTRYPOINT ["./setup.sh"]