FROM python:3.7.4-alpine3.10

RUN /sbin/apk add --no-cache postgresql-client su-exec

COPY . /pg-backup
RUN chmod +x /pg-backup/docker-entrypoint.sh

ENTRYPOINT ["/pg-backup/docker-entrypoint.sh"]

ENV PYTHONUNBUFFERED="1" \
    USER_SPEC="1000:1000"

LABEL maintainer=william@subtlecoolness.com \
      org.label-schema.schema-version=1.0 \
      org.label-schema.version=1.0.0
