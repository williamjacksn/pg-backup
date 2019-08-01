import datetime
import logging
import os
import pathlib
import subprocess
import sys

from typing import List


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
        if self._databases is None:
            return []
        return [d.strip() for d in self._databases.split(',')]

    @property
    def destination(self) -> pathlib.Path:
        return pathlib.Path(self._destination).resolve()

    @property
    def version(self) -> str:
        """Read version from Dockerfile"""
        dockerfile = pathlib.Path(__file__).resolve().parent / 'Dockerfile'
        with open(dockerfile) as f:
            for line in f:
                if 'org.opencontainers.image.version' in line:
                    return line.strip().split('=', maxsplit=1)[1]
        return 'unknown'


def main():
    config = Config()
    logging.basicConfig(format=config.log_format, level='DEBUG', stream=sys.stdout)
    logging.debug(f'pg-backup {config.version}')
    logging.debug(f'Changing log level to {config.log_level}')
    logging.getLogger().setLevel(config.log_level)
    for db in config.databases:
        backup_file = config.destination / f'{datetime.date.today()}-{db}.sql'
        logging.info(f'Backing up {db} to {backup_file}')
        cmd = ['/usr/bin/pg_dump', '--clean', '--create', '--if-exists', '-d', f'{config.dsn}/{db}',
               '-f', str(backup_file)]
        subprocess.run(cmd)


if __name__ == '__main__':
    main()
