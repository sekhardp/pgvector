# syntax=docker/dockerfile:1

ARG PG_MAJOR=17
ARG DEBIAN_CODENAME=bookworm
FROM postgres:$PG_MAJOR-$DEBIAN_CODENAME
ARG PG_MAJOR

ADD https://github.com/pgvector/pgvector.git#v0.8.6 /tmp/pgvector

RUN set -eux; \
		apt-get update && \
		apt-mark hold locales && \
		apt-get install -y --no-install-recommends build-essential postgresql-server-dev-$PG_MAJOR && \
		cd /tmp/pgvector && \
		make OPTFLAGS="" && \
		make install && \
		install -d /usr/share/doc/pgvector && \
		install -m 644 LICENSE README.md /usr/share/doc/pgvector && \
		rm -r /tmp/pgvector && \
		apt-get purge -y build-essential postgresql-server-dev-$PG_MAJOR && \
		apt-get autoremove -y && \
		rm -rf /var/lib/apt/lists/*
