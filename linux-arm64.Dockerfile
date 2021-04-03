FROM ghcr.io/hotio/base@sha256:6ec661372b55345030f6b695cbbf3c6cf3d2e4fa204abd04b26e33d6bb1f6280

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6587FFD6536B8826E88A62547876AE518CBCF2F2 && echo "deb http://ppa.launchpad.net/ubuntu-raspi2/ppa-nightly/ubuntu focal main" | tee /etc/apt/sources.list.d/raspberrypi.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libicu66 \
        libass9 libbluray2 libdrm2 libfribidi0 libmp3lame0 libopus0 libtheora0 libva-drm2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libwebp6 libwebpmux3 libx11-6 libx264-155 libx265-179 libzvbi0 libvpx6 \
        at \
        libfontconfig1 \
        libfreetype6 \
        libomxil-bellagio0 \
        libomxil-bellagio-bin \
        libraspberrypi0 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION
RUN debfile="/tmp/ffmpeg.deb" && wget2 -nc -O "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/jellyfin-ffmpeg_${FFMPEG_VERSION}-focal_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG VERSION
ARG WEB_VERSION
RUN debfile="/tmp/jellyfin.deb" && wget2 -nc -O "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/stable/server/jellyfin-server_${VERSION}_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}" && \
    debfile="/tmp/jellyfin.deb" && wget2 -nc -O "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/stable/web/jellyfin-web_${WEB_VERSION}_all.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
