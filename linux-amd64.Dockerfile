FROM ghcr.io/hotio/base@sha256:dd2e4e2d04e6a251ee3249d491ca1f198e0514bcd3d301faf01310d6cf9bfd65

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libicu66 \
        libass9 libbluray2 libdrm2 libfribidi0 libmp3lame0 libopus0 libtheora0 libva-drm2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libwebp6 libwebpmux3 libx11-6 libx264-155 libx265-179 libzvbi0 ocl-icd-libopencl1 libvpx6 \
        at \
        libfontconfig1 \
        libfreetype6 \
        libdrm-intel1 \
        i965-va-driver \
        mesa-va-drivers \
        intel-media-va-driver-non-free && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION
RUN debfile="/tmp/ffmpeg.deb" && wget2 -nc -O "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/jellyfin-ffmpeg_${FFMPEG_VERSION}-focal_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG VERSION
ARG WEB_VERSION
RUN debfile="/tmp/jellyfin.deb" && wget2 -nc -O "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/stable/server/jellyfin-server_${VERSION}_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}" && \
    debfile="/tmp/jellyfin.deb" && wget2 -nc -O "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/stable/web/jellyfin-web_${WEB_VERSION}_all.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
