# Coolify WordPress LMS Template

## Repository Layout

```text
.coolify/compose.yaml
wordpress/Dockerfile
wordpress/.dockerignore
wordpress/php/uploads.ini
wordpress/plugins/
```

Drop extracted premium plugins or premium plugin zip files into `wordpress/plugins/`.
The Docker image downloads the free `masteriyo` and `redis-cache` plugins during build, then seeds all plugin files into `/usr/src/wordpress/wp-content/plugins/` so the upstream WordPress entrypoint can initialize the named `wp-content` volume on first boot.

## Coolify Setup

1. Create a new Coolify project from this GitHub template repository.
2. Set the Docker Compose file path to `.coolify/compose.yaml`.
3. Set the build context behavior to use the repository root. The Compose file references `../wordpress` because Docker Compose resolves relative paths from `.coolify/`.
4. Add all variables from `.env.sample` in Coolify's environment variable UI.
5. Generate strong values for all `WORDPRESS_*_KEY`, `WORDPRESS_*_SALT`, `MARIADB_PASSWORD`, `MARIADB_ROOT_PASSWORD`, and `REDIS_PASSWORD`.
6. Set `WORDPRESS_TABLE_PREFIX` to a short prefix ending in `_`.
7. Set `WORDPRESS_CACHE_KEY_SALT` to a unique value for this site.
8. Set the Masteriyo social login variables in Coolify, not in git:

```text
MASTERIYO_GOOGLE_CLIENT_ID
MASTERIYO_GOOGLE_CLIENT_SECRET
MASTERIYO_FACEBOOK_APP_ID
MASTERIYO_FACEBOOK_APP_SECRET
```

9. Deploy the stack.
10. In WordPress, activate Masteriyo, Masteriyo Pro, and Redis Object Cache.
11. In Redis Object Cache settings, enable object caching.
12. In Masteriyo Pro Social Login settings, configure Google and Facebook using the credentials stored in Coolify. If the add-on UI does not read environment constants directly, enter the credentials in the WordPress admin; they will be stored in the database and protected by the database backup runbook below.

## Database Backup Runbook

1. Open the Coolify resource for the `database` service.
2. Open the Database Backups section.
3. Create a new S3-compatible destination.
4. For Cloudflare R2, use the R2 endpoint URL, bucket name, access key ID, and secret access key from Cloudflare.
5. For AWS S3, use the AWS region endpoint, bucket name, access key ID, and secret access key from AWS IAM.
6. Set the backup schedule to daily.
7. Set a retention policy that matches the course data recovery requirement.
8. Run a manual backup once and confirm the object appears in the bucket.
9. Run a restore test into a disposable database before relying on the schedule for production.

The database backup protects WordPress settings, Masteriyo courses, student progress, enrollments, orders, users, and social login settings stored in WordPress.

## File Backup Runbook

Back up `wp-content/uploads` outside the server. The deployment persists `wp-content` in the `wordpress-content` Docker volume, which includes uploads, plugin-generated assets, and LMS course media.

Recommended production pattern:

1. Use an S3-compatible offload plugin for WordPress uploads, configured for Cloudflare R2 or AWS S3.
2. Keep local files enabled until the offload target has been verified.
3. Add lifecycle and versioning rules in the bucket for recovery from accidental deletion.
4. Schedule a periodic server-side volume backup if uploads remain local.
5. Test restoring both the database and uploaded files together.
