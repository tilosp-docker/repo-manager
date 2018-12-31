FROM rust AS build

ENV VERSION 0.1.1

RUN git clone --branch $VERSION --depth 1 https://github.com/alexlarsson/repo-manager.git

WORKDIR repo-manager

RUN cargo build --release

FROM debian:stretch-slim

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
        libpq5 \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /repo-manager/target/release/gentoken /repo-manager/target/release/repo-manager /usr/bin/

RUN set -ex; \
    groupadd -g 1000 repo-manager; \
    useradd -u 1000 -g 1000 -m -s /bin/bash repo-manager

USER repo-manager
