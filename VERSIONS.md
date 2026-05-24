# Pinned Production Versions

These versions are intentionally pinned for reproducible Coolify builds. Update them only after testing the full LMS stack in staging.

| Component | Version / Tag | Where it is pinned |
| --- | --- | --- |
| WordPress + PHP + Apache | `wordpress:6.9.4-php8.3-apache` | `wordpress/Dockerfile` |
| MariaDB | `mariadb:11.4.10-noble` | `.coolify/compose.yaml` |
| Redis | `redis:7.4.9-alpine3.21` | `.coolify/compose.yaml` |
| WP-CLI | `2.12.0` | `wordpress/Dockerfile` |
| Masteriyo Free | `learning-management-system` `2.2.1` | `wordpress/Dockerfile` |
| Redis Object Cache plugin | `redis-cache` `2.8.0` | `wordpress/Dockerfile` |

## Upgrade Checklist

1. Update the pinned value in the file listed above.
2. Rebuild the WordPress image in staging.
3. Confirm WordPress admin loads without PHP warnings or fatal errors.
4. Confirm Masteriyo Free and Masteriyo Pro activate together.
5. Confirm Redis Object Cache connects and can enable the object-cache drop-in.
6. Run through login, social login, course enrollment, course progress, checkout, and file upload flows.
7. Take a database backup before applying the version change in production.
