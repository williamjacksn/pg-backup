FROM python:3.9.3-alpine3.13

RUN /sbin/apk add --no-cache postgresql-client

COPY pg_backup.py /pg-backup/pg_backup.py

ENTRYPOINT ["/usr/local/bin/python"]
CMD ["/pg-backup/pg_backup.py"]

ENV APP_VERSION="2021.1" \
    PYTHONUNBUFFERED="1"

LABEL org.opencontainers.image.authors="William Jackson <william@subtlecoolness.com>" \
      org.opencontainers.image.source="https://github.com/williamjacksn/pg-backup" \
      org.opencontainers.image.version="${APP_VERSION}"
