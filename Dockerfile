FROM python:3.7.1-alpine3.8

COPY requirements.txt /pg-backup/requirements.txt

RUN /sbin/apk add --no-cache postgresql-client su-exec \
 && /usr/local/bin/pip install --no-cache-dir --requirement /pg-backup/requirements.txt

COPY . /pg-backup
RUN chmod +x /pg-backup/docker-entrypoint.sh

ENTRYPOINT ["/pg-backup/docker-entrypoint.sh"]

ENV PYTHONUNBUFFERED 1
ENV USER_SPEC 1000:1000

LABEL maintainer=william@subtlecoolness.com \
      org.label-schema.schema-version=1.0 \
      org.label-schema.version=0.0.4
