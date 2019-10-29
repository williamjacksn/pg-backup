FROM python:3.8.0-alpine3.10

RUN /sbin/apk add --no-cache postgresql-client su-exec

COPY pg_backup.py /pg-backup/pg_backup.py

ENTRYPOINT ["/usr/local/bin/python"]
CMD ["/pg-backup/pg_backup.py"]

ENV APP_VERSION="1.0.1" \
    PYTHONUNBUFFERED="1"

LABEL org.opencontainers.image.authors="William Jackson <william@subtlecoolness.com>" \
      org.opencontainers.image.source="https://github.com/williamjacksn/pg-backup" \
      org.opencontainers.image.version="${APP_VERSION}"
