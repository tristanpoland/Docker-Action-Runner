# Docker GitHub Actions Runner

A containerized self-hosted GitHub Actions runner that allows you to run your GitHub Actions workflows in Docker with improved security.

## Features

- Automatically downloads and configures the latest GitHub Actions runner
- Runs as a Docker container for easy deployment and isolation
- Supports organization-level runner registration
- Configurable via environment variables
- Includes ephemeral mode for auto-deregistration after job completion

## Self hosted runner limitations (From [GitHub Docs](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#usage-limits))
There are some limits on GitHub Actions usage when using self-hosted runners. These limits are subject to change.

- Job execution time - Each job in a workflow can run for up to 5 days of execution time. If a job reaches this limit, the job is terminated and fails to complete.

- Workflow run time - Each workflow run is limited to 35 days. If a workflow run reaches this limit, the workflow run is cancelled. This period includes execution duration, and time spent on waiting and approval.

- Job queue time - Each job for self-hosted runners that has been queued for at least 24 hours will be canceled. The actual time in queue can reach up to 48 hours before cancellation occurs. If a self-hosted runner does not start executing the job within this limit, the job is terminated and fails to complete.

- API requests - You can execute up to 1,000 requests to the GitHub API in an hour across all actions within a repository. If requests are exceeded, additional API calls will fail which might cause jobs to fail.

- Job matrix - A job matrix can generate a maximum of 256 jobs per workflow run. This limit applies to both GitHub-hosted and self-hosted runners.

- Workflow run queue - No more than 500 workflow runs can be queued in a 10 second interval per repository. If a workflow run reaches this limit, the workflow run is terminated and fails to complete.

- Registering self-hosted runners - You can have a maximum of 10,000 self-hosted runners in one runner group. If this limit is reached, adding a new runner will not be possible.

## Prerequisites

- Docker and Docker Compose installed on your host machine
- GitHub Personal Access Token with appropriate permissions
- GitHub Organization name

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/your-username/docker-github-runner.git
cd docker-github-runner
```

### 2. Create a .env file

Create a `.env` file in the project directory with your GitHub credentials:

```
GITHUB_ORG=your-organization
ACCESS_TOKEN=your-token
```

**Important**: Add `.env` to your `.gitignore` file to prevent accidentally committing secrets:

```bash
echo ".env" >> .gitignore
```

### 3. Start the runner

```bash
docker-compose up -d
```

This builds the Docker image and starts the container with your environment variables.

### 4. Check runner status

```bash
docker-compose logs
```

## Configuration

The runner is configured using the following environment variables:

| Variable | Description |
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
- `docker-compose.yml`: Manages container deployment and environment variables
- `setup.sh`: Script to download, configure, and start the runner
- `.env`: Contains your secrets (not committed to version control)

## Security Considerations

- Environment variables are only available at runtime, not baked into the image
- The `.env` file should never be committed to your repository
- Consider using a secrets management solution for production deployments
- The runner will have access to the code and workflows that it executes

## Troubleshooting

If the runner fails to start or register:

1. Check your access token has the correct permissions
2. Verify your organization name is correct
3. Examine the container logs: `docker-compose logs`
4. Ensure your `.env` file is in the correct location

## License

[MIT License](LICENSE)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.