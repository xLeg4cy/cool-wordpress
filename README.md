# Cool-Wordpress

A Docker Compose-based WordPress environment optimized for deployment on Coolify. This setup features automated WordPress installation, pre-configured database handling, and Composer-managed plugins and themes using WPackagist.

## Features

- **Automated Setup:** The `wordpress-cli` container automatically downloads and installs WordPress, configuring it using environment variables. It also strips out default themes and plugins (like Twenty Twenty-Four, Hello Dolly, and Akismet) to provide a clean slate.
- **Composer Integrated:** Automatically installs Composer on startup. Manage your WordPress plugins and themes as dependencies via `composer.json` using [WPackagist](https://wpackagist.org/).
- **Docker Compose Architecture:** Includes services for `wordpress`, `wordpress-cli`, `db` (MariaDB), and `phpmyadmin`.
- **Custom Helper Script:** A built-in CLI tool (`.bin/ve`) for simplifying common development tasks like managing containers, running WP-CLI commands, and managing Composer.

## Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- [Bun](https://bun.sh/) (optional, if you plan to use frontend tooling configured in the project)

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd cool-wordpress
   ```

2. **Configure Environment Variables:**
   Copy the provided `.env.sample` to `.env` and fill in the necessary details.
   ```bash
   cp .env.sample .env
   ```
   
   *Example `.env` configuration:*
   ```env
   DB_NAME=wordpress
   DB_PORT=8080
   
   SERVICE_PASSWORD_ROOT=root_password
   SERVICE_USER_DB=wp_user
   SERVICE_PASSWORD_DB=wp_password
   
   WP_USER=admin
   WP_PASSWORD=admin_password
   
   WP_TITLE="My Cool WordPress Site"
   WP_EMAIL=admin@example.com
   WP_PORT=8000
   ```

3. **Start the Environment:**
   Use the included helper script to bring up the environment:
   ```bash
   ./.bin/ve up
   ```

   The initialization process will handle the database creation, wait for WordPress to be ready, and perform the installation based on your `.env` settings.

4. **Access the Site:**
   - WordPress Site: `http://localhost:<WP_PORT>`
   - phpMyAdmin: `http://localhost:<DB_PORT>`

## Project Structure

- `compose.yaml`: Docker Compose configuration defining the services (`wordpress`, `wordpress-cli`, `db`, `phpmyadmin`).
- `composer.json`: Dependency management for WordPress plugins/themes.
- `config/custom.ini`: Custom PHP configuration loaded into the WordPress containers.
- `.bin/ve`: Bash helper script for managing the environment.
- `wp-content/`: Mounted volume containing your WordPress content (themes, plugins, uploads).

## Managing Dependencies

This project uses Composer to manage WordPress plugins and themes via [WPackagist](https://wpackagist.org/). 
To add a new plugin (e.g., `advanced-custom-fields`):

```bash
# Add to composer.json and install
./.bin/ve composer require wpackagist-plugin/advanced-custom-fields
```

## Helper CLI (`.bin/ve`)

The project includes a convenient shell script `.bin/ve` to interact with your environment without typing long Docker commands.

### Available Commands:

| Command | Description |
|---|---|
| `install` | Install dependencies (composer, bun) |
| `update` | Update composer dependencies |
| `up` | Start services with docker compose |
| `stop` | Stop services |
| `down` | Stop and remove containers and networks |
| `destroy` | Stop, remove containers, networks, and volumes |
| `reset` | Destroy and bring up services again |
| `exec` | Execute a command in the wordpress container |
| `shell` | Open a bash shell in the wordpress container |
| `cli` | Run a WP-CLI command (e.g., `./.bin/ve cli plugin list`) |
| `composer`| Run a composer command in the wordpress container |
| `status` | View status of containers |

Usage example:
```bash
# Run a WP-CLI command
./.bin/ve cli option get siteurl

# Open an interactive shell inside the WordPress container
./.bin/ve shell
```
