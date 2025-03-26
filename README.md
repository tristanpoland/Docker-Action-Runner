# Docker GitHub Actions Runner

A containerized self-hosted GitHub Actions runner that allows you to run your GitHub Actions workflows locally in Docker.

## Features

- Automatically downloads and configures the latest GitHub Actions runner
- Runs as a Docker container for easy deployment and isolation
- Supports organization-level runner registration
- Configurable via environment variables or build arguments
- Includes ephemeral mode for auto-deregistration after job completion

## Prerequisites

- Docker installed on your host machine
- GitHub Personal Access Token with appropriate permissions
- GitHub Organization name

## Quick Start

### Build the Docker image

```bash
make build GITHUB_ORG=your-organization ACCESS_TOKEN=your-token
```

Or build manually:

```bash
docker build --tag github-runner \
  --build-arg GITHUB_ORG=your-organization \
  --build-arg ACCESS_TOKEN=your-token .
```

### Run the container

```bash
docker run -d --name github-runner github-runner
```

## Configuration

The runner can be configured using the following build arguments:

| Argument | Description |
|----------|-------------|
| `GITHUB_ORG` | Your GitHub organization name |
| `ACCESS_TOKEN` | GitHub Personal Access Token |

## Personal Access Token

You need to create a GitHub Personal Access Token with the following permissions:

- `admin:org` (for organization-level runner)
- `repo` (for repository-level runner)

## Using in GitHub Workflows

To use your self-hosted runner in GitHub workflows, specify the `runs-on` parameter as `self-hosted`:

```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v3
      # Your workflow steps...
```

## Files

- `Dockerfile`: Defines the Docker image for the runner
- `setup.sh`: Script to download, configure, and start the runner
- `makefile`: Simplifies the build process

## Security Considerations

- The container requires a GitHub Personal Access Token, handle it securely
- Consider using secrets management for production deployments
- The runner will have access to the code and workflows that it executes

## Troubleshooting

If the runner fails to start or register:

1. Check your access token has the correct permissions
2. Verify your organization name is correct
3. Examine the container logs: `docker logs github-runner`

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.