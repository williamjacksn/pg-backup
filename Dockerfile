FROM python:3.8.6-alpine3.12

RUN /sbin/apk add --no-cache postgresql-client

COPY pg_backup.py /pg-backup/pg_backup.py

ENTRYPOINT ["/usr/local/bin/python"]
CMD ["/pg-backup/pg_backup.py"]

ENV APP_VERSION="2020.1" \
    PYTHONUNBUFFERED="1"

LABEL org.opencontainers.image.authors="William Jackson <william@subtlecoolness.com>" \
      org.opencontainers.image.source="https://github.com/williamjacksn/pg-backup" \
      org.opencontainers.image.version="${APP_VERSION}"
