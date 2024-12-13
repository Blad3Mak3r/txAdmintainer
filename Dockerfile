FROM alpine:latest AS base

WORKDIR /opt/fivem

# Install FiveM Release
RUN wget -O- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/7290-a654bcc2adfa27c4e020fc915a1a6343c3b4f921/fx.tar.xz | tar -xJ -C /opt/fivem
RUN chmod +x /opt/fivem/run.sh

CMD ["sh", "./run.sh"]