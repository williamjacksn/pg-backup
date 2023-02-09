FROM python:3.11.2-alpine3.16

RUN /sbin/apk add --no-cache postgresql14-client

COPY pg_backup.py /pg-backup/pg_backup.py

ENTRYPOINT ["/usr/local/bin/python"]
CMD ["/pg-backup/pg_backup.py"]

ENV APP_VERSION="2022.1" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    TZ="Etc/UTC"

LABEL org.opencontainers.image.authors="William Jackson <william@subtlecoolness.com>" \
      org.opencontainers.image.source="https://github.com/williamjacksn/pg-backup" \
      org.opencontainers.image.version="${APP_VERSION}"
