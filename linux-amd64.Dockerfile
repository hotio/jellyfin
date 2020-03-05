FROM hotio/dotnetcore@sha256:71eacddba2049349b101b0e0fc8a83a0b61284ab7762755497e54097f4cda041

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

VOLUME ["/transcode"]

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libfontconfig1 \
        libfreetype6 && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION=4.2.1-5

# install ffmpeg
RUN debfile="/tmp/ffmpeg.deb" && curl -fsSL -o "${debfile}" "https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${FFMPEG_VERSION}/jellyfin-ffmpeg_${FFMPEG_VERSION}-bionic_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG JELLYFIN_VERSION=10.4.3

# install app
RUN debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://github.com/jellyfin/jellyfin/releases/download/v${JELLYFIN_VERSION}/jellyfin_${JELLYFIN_VERSION}-1_ubuntu-amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
