# The following line is for Dependabot.
# When a new version of PostgreSQL is available,
# update the client version in the apt-get command below
FROM postgres:17

FROM python:3.13-slim

ARG DEBIAN_FRONTEND=noninteractive
RUN /usr/bin/apt-get update \
 && /usr/bin/apt-get install --assume-yes postgresql-common \
 && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
 && /usr/bin/apt-get install --assume-yes postgresql-client-17 \
 && rm -rf /var/lib/apt/lists/*

RUN /usr/sbin/useradd --create-home --shell /bin/bash --user-group python

USER python
RUN /usr/local/bin/python -m venv /home/python/venv

COPY --chown=python:python pg_backup.py /home/python/pg-backup/pg_backup.py

ENTRYPOINT ["/home/python/venv/bin/python"]
CMD ["/home/python/pg-backup/pg_backup.py"]

ENV PATH="/home/python/venv/bin/python:${PATH}" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    TZ="Etc/UTC"

LABEL org.opencontainers.image.authors="William Jackson <william@subtlecoolness.com>" \
      org.opencontainers.image.source="https://github.com/williamjacksn/pg-backup"
