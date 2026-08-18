# syntax=docker/dockerfile:1

ARG PG_MAJOR=17
ARG DEBIAN_CODENAME=bookworm
FROM postgres:$PG_MAJOR-$DEBIAN_CODENAME
ARG PG_MAJOR
ARG PGVECTOR_VERSION=v0.8.6

RUN set -eux; \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			build-essential \
			git \
			postgresql-server-dev-$PG_MAJOR; \
		git clone --depth 1 --branch "${PGVECTOR_VERSION}" \
        	https://github.com/pgvector/pgvector.git /tmp/pgvector; \
		cd /tmp/pgvector; \
		make OPTFLAGS=""; \
		make install; \
		install -d /usr/share/doc/pgvector; \
		install -m 644 LICENSE README.md /usr/share/doc/pgvector; \
		rm -r /tmp/pgvector; \
		apt-get purge -y --auto-remove \
			build-essential \
			git \
			postgresql-server-dev-$PG_MAJOR; \
		rm -rf /var/lib/apt/lists/*
