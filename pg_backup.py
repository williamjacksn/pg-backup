import datetime
import logging
import os
import pathlib
import subprocess
import sys

from typing import List

version = '0.0.1'


class Config:
    _destination: str
    _databases: str
    dsn: str
    log_format: str
    log_level: str

    def __init__(self):
        self._destination = os.getenv('DESTINATION')
        self._databases = os.getenv('DATABASES')
        self.dsn = os.getenv('DSN')
        self.log_format = os.getenv('LOG_FORMAT', '%(levelname)s [%(name)s] %(message)s')
        self.log_level = os.getenv('LOG_LEVEL', 'DEBUG')

    @property
    def databases(self) -> List[str]:
        return [d.strip() for d in self._databases.split(',')]

    @property
    def destination(self) -> pathlib.Path:
        return pathlib.Path(self._destination).resolve()


def main():
    config = Config()
    logging.basicConfig(format=config.log_format, level=config.log_level, stream=sys.stdout)
    logging.info(f'pg-backup {version}')
    for db in config.databases:
        backup_file = config.destination / f'{datetime.date.today()}-{db}.sql'
        logging.info(f'Backing up {db} to {backup_file}')
        cmd = ['/usr/bin/pg_dump', '--clean', '--create', '--if-exists', '-d', f'{config.dsn}/{db}',
               '-f', str(backup_file)]
        subprocess.run(cmd)


if __name__ == '__main__':
    main()
