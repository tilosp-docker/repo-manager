FROM rust AS build

ENV VERSION 0.1.1

RUN git clone --branch $VERSION --depth 1 https://github.com/alexlarsson/repo-manager.git

WORKDIR repo-manager

RUN cargo build --release

FROM fedora

RUN set -ex; \
	dnf install -y \
		postgresql-libs \
		flatpak \
		ostree \
	; \
	dnf clean all

COPY --from=build /repo-manager/target/release/gentoken /repo-manager/target/release/repo-manager /usr/bin/

RUN set -ex; \
    groupadd -g 1000 repo-manager; \
    useradd -u 1000 -g 1000 -m -s /bin/bash repo-manager

USER repo-manager

WORKDIR /home/repo-manager

EXPOSE 8080

CMD ["repo-manager"]
