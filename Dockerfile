FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    iputils-ping \
    tar \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the actions runner
RUN useradd -m runner

# Set up work directory
WORKDIR /home/runner/actions-runner

# Give ownership to the runner user
RUN chown -R runner:runner /home/runner

# Switch to the runner user
USER runner

# Copy the runner setup script
COPY --chown=runner:runner setup.sh .
RUN chmod +x setup.sh

# Start the runner
ENTRYPOINT ["./setup.sh"]