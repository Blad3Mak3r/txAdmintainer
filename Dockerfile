FROM alpine:latest AS base

LABEL org.opencontainers.image.source=https://github.com/Blad3Mak3r/txAdmintainer

RUN apk update --no-cache && apk upgrade --no-cache
RUN apk --no-cache add libgcc libstdc++ ca-certificates npm tzdata 
RUN npm i -g fvm-installer

ARG VERSION=12031-1baa5c805bb6d2947321f1e82fa3aec8836b20b1
ARG DOWNLOAD_URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${VERSION}/fx.tar.xz

FROM base AS downloader

# Install FiveM Release
RUN mkdir /tmp/fivem
RUN wget -O- ${DOWNLOAD_URL} | tar -xJ -C /tmp/fivem

FROM base AS runtime

ARG TX_DATA_PATH=/etc/fivem/txData

COPY --from=downloader /tmp/fivem /opt/fivem/
RUN chmod +x /opt/fivem/run.sh

RUN addgroup -g 1000 -S cfx && adduser -u 1000 -S cfx -G cfx
RUN mkdir -p ${TX_DATA_PATH} && chown cfx:cfx ${TX_DATA_PATH}

USER cfx
# Data folder
VOLUME ${TX_DATA_PATH}

EXPOSE 30120/tcp 30120/udp 40120/tcp

WORKDIR /opt/fivem

CMD ["sh", "/opt/fivem/run.sh", "+set", "txDataPath", "/etc/fivem/txData"]