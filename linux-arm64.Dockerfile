FROM hotio/dotnetcore@sha256:817f18af01df8e9710c836e6b9e7b7f27a87141c6b1e6d243bbc3e818576c3e7

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libass9 libbluray2 libdrm2 libfribidi0 libmp3lame0 libopus0 libtheora0 libva-drm2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libwebp6 libwebpmux3 libx11-6 libx264-152 libx265-146 libzvbi0 \
        at \
        libfontconfig1 \
        libfreetype6 && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION=4.2.1-5

# install ffmpeg
RUN debfile="/tmp/ffmpeg.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/jellyfin-ffmpeg_${FFMPEG_VERSION}-bionic_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG JELLYFIN_VERSION=20200320

# install app
RUN debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/nightly/jellyfin-nightly_${JELLYFIN_VERSION}_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
