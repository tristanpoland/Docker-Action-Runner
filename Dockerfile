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

# Copy the runner setup script
COPY setup.sh .
RUN chmod +x setup.sh

# Start the runner
ENTRYPOINT ["./setup.sh"]