FROM hotio/base@sha256:637f0df3ce9b8f04302d94c92d0281a434c476f5faefe2f3e9ac918866d3b0ab

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libicu60 \
        libass9 libbluray2 libdrm2 libfribidi0 libmp3lame0 libopus0 libtheora0 libva-drm2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libwebp6 libwebpmux3 libx11-6 libx264-152 libx265-146 libzvbi0 ocl-icd-libopencl1 libvpx5 \
        at \
        libfontconfig1 \
        libfreetype6 \
        libdrm-intel1 \
        i965-va-driver \
        mesa-va-drivers \
        intel-media-va-driver && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION
RUN debfile="/tmp/ffmpeg.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/jellyfin-ffmpeg_${FFMPEG_VERSION}-focal_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG VERSION
ARG WEB_VERSION
RUN debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/stable/server/jellyfin-server_${VERSION}_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}" && \
    debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/stable/web/jellyfin-web_${WEB_VERSION}_all.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
