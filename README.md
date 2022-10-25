# pg-backup

Wrapper for pg_dump

## Usage

Set the following environment variables:

*   `DATABASES`: space-delimited list of databases to back up
*   `DESTINATION`: path to a folder to save the database backup files in
*   `DSN`: connection string for the database server *without* a database specified 
*   `LOG_FORMAT`: optional, the format for all output (default: `%(levelname)s [%(name)s] %(message)s`)
*   `LOG_LEVEL`: optional, the log level for all output (default: `INFO`)

Then run the tool:

    python pg_backup.py

## Example `compose.yaml`

```yaml
services:
  pg-backup:
    image: williamjackson/pg-backup
    user: 1000:1000
    environment:
      DATABASES: app_db postgres william
      DESTINATION: /db-backups
      DSN: postgresql://username:password@db_host
    volumes:
      - /home/william/db-backups:/db-backups
```

## Example `docker` command

```sh
docker container run \
  -u 1000:1000
  -e DATABASES="app_db postgres william" \
  -e DESTINATION=/db-backups \
  -e DSN=postgresql://username:password@db_host \
  -v /home/william/db-backups:/db-backups \
  williamjackson/pg-backup
```
