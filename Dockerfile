FROM python:3.7.2-alpine3.9

RUN /sbin/apk add --no-cache postgresql-client su-exec

COPY . /pg-backup
RUN chmod +x /pg-backup/docker-entrypoint.sh

ENTRYPOINT ["/pg-backup/docker-entrypoint.sh"]

ENV PYTHONUNBUFFERED 1
ENV USER_SPEC 1000:1000

LABEL maintainer=william@subtlecoolness.com \
      org.label-schema.schema-version=1.0 \
      org.label-schema.version=0.0.4
