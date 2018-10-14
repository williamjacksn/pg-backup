FROM python:3.7.0-alpine3.8

ENV USER_SPEC 1000:1000

RUN /sbin/apk add --no-cache postgresql-client su-exec \
 && /usr/local/bin/pip install --no-cache-dir --upgrade pip setuptools wheel

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY pg_backup.py /pg_backup.py

ENTRYPOINT ["/docker-entrypoint.sh"]

LABEL maintainer=william@subtlecoolness.com \
      org.label-schema.schema-version=1.0 \
      org.label-schema.version=0.0.1
