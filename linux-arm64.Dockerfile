FROM hotio/dotnetcore@sha256:6f081711d6b79cd97d5f1feccaf3fb48d4bc3dc06a9e3958a378ebc7820cd2ab

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
RUN debfile="/tmp/ffmpeg.deb" && curl -fsSL -o "${debfile}" "https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${FFMPEG_VERSION}/jellyfin-ffmpeg_${FFMPEG_VERSION}-bionic_arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG JELLYFIN_VERSION=10.4.3

# install app
RUN debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://github.com/jellyfin/jellyfin/releases/download/v${JELLYFIN_VERSION}/jellyfin_${JELLYFIN_VERSION}-1_ubuntu-arm64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
