import datetime
import logging
import os
import pathlib
import subprocess
import sys

from typing import List


class Settings:
    databases: List[str]
    destination: pathlib.Path
    dsn: str
    log_format: str
    log_level: str
    version: str

    def __init__(self):
        self.databases = os.getenv('DATABASES', '').split()
        self.destination = pathlib.Path(os.getenv('DESTINATION')).resolve()
        self.dsn = os.getenv('DSN')
        self.log_format = os.getenv('LOG_FORMAT', '%(levelname)s [%(name)s] %(message)s')
        self.log_level = os.getenv('LOG_LEVEL', 'INFO')
        self.version = '2024.2'


def main():
    settings = Settings()
    logging.basicConfig(format=settings.log_format, level='DEBUG', stream=sys.stdout)
    logging.debug(f'pg-backup {settings.version}')
    logging.debug(f'Changing log level to {settings.log_level}')
    logging.getLogger().setLevel(settings.log_level)
    for db in settings.databases:
        backup_file = settings.destination / f'{datetime.date.today()}-{db}.sql'
        logging.info(f'Backing up {db} to {backup_file}')
        cmd = ['/usr/bin/pg_dump', '--clean', '--create', '--if-exists', '-d', f'{settings.dsn}/{db}',
               '-f', str(backup_file)]
        subprocess.run(cmd)


if __name__ == '__main__':
    main()
