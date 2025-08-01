# The following line is for Dependabot.
# When a new version of PostgreSQL is available,
# update the client version in the apt-get command below
FROM postgres:17

FROM ghcr.io/astral-sh/uv:0.8.3-bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
RUN /usr/bin/apt-get update \
 && /usr/bin/apt-get install --assume-yes postgresql-common \
 && /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y \
 && /usr/bin/apt-get install --assume-yes postgresql-client-17 \
 && rm -rf /var/lib/apt/lists/*

RUN /usr/sbin/useradd --create-home --shell /bin/bash --user-group python
USER python

WORKDIR /app
COPY --chown=python:python .python-version pyproject.toml uv.lock ./
RUN /usr/local/bin/uv sync --frozen

COPY --chown=python:python pg_backup.py ./

ENTRYPOINT ["uv", "run", "pg_backup.py"]

ENV PATH="/app/.venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    TZ="Etc/UTC"

LABEL org.opencontainers.image.authors="William Jackson <william@subtlecoolness.com>" \
      org.opencontainers.image.source="https://github.com/williamjacksn/pg-backup"
