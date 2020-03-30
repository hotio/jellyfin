FROM hotio/dotnetcore@sha256:ee29e0573ce844055e724eff308df38ed1e9a121255bb69d989fb2c3115f141c

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6587FFD6536B8826E88A62547876AE518CBCF2F2 && echo "deb http://ppa.launchpad.net/ubuntu-raspi2/ppa/ubuntu bionic main" | tee /etc/apt/sources.list.d/raspberrypi.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libass9 libbluray2 libdrm2 libfribidi0 libmp3lame0 libopus0 libtheora0 libva-drm2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libwebp6 libwebpmux3 libx11-6 libx264-152 libx265-146 libzvbi0 \
        at \
        libfontconfig1 \
        libfreetype6 \
        libraspberrypi0 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION=4.2.1-5

# install ffmpeg
RUN debfile="/tmp/ffmpeg.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/jellyfin-ffmpeg_${FFMPEG_VERSION}-bionic_armhf.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG JELLYFIN_VERSION=20200330

# install app
RUN debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/nightly/jellyfin-nightly_${JELLYFIN_VERSION}_armhf.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
