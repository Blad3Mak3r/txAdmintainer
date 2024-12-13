FROM alpine:latest AS base

RUN apk update --no-cache && apk upgrade --no-cache
RUN apk --no-cache add libgcc libstdc++ ca-certificates npm tzdata 
RUN npm i -g fvm-installer

ARG VERSION=12031-1baa5c805bb6d2947321f1e82fa3aec8836b20b1
ARG DOWNLOAD_URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${VERSION}/fx.tar.xz

WORKDIR /opt/fivem

FROM base AS downloader

# Install FiveM Release
RUN wget -O- ${DOWNLOAD_URL} | tar -xJ -C /opt/fivem
RUN chmod +x /opt/fivem/run.sh

FROM base AS runtime

COPY --from=downloader /opt/fivem /opt/fivem/

# Data folder
VOLUME /opt/fivem/txData

CMD ["sh", "./run.sh"]