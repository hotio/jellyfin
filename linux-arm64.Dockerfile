FROM cr.hotio.dev/hotio/base@sha256:db1cde4fa018c4e9a472a32fbfeabe04ec7a5c278813e44c1d347d06e1ceda4f

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6587FFD6536B8826E88A62547876AE518CBCF2F2 && \
    echo "deb http://ppa.launchpad.net/ubuntu-raspi2/ppa-nightly/ubuntu focal main" | tee /etc/apt/sources.list.d/raspberrypi.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libomxil-bellagio0 \
        libomxil-bellagio-bin \
        libraspberrypi0 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install jellyfin
ARG VERSION
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    curl -fsSL "https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key" | apt-key add - && \
    echo "deb [arch=arm64] https://repo.jellyfin.org/ubuntu focal main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    echo "deb [arch=arm64] https://repo.jellyfin.org/ubuntu focal unstable" | tee -a /etc/apt/sources.list.d/jellyfin.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        jellyfin-server=${VERSION}-unstable \
        jellyfin-web \
        jellyfin-ffmpeg5 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /
RUN chmod -R +x /etc/cont-init.d/ /etc/services.d/
