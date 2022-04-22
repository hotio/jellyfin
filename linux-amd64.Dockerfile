FROM cr.hotio.dev/hotio/base@sha256:453a0df72a0639063c43d39bfa60063ef0657a99b2fe8f4ce55d20b2ad353bd7

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        nvidia-opencl-icd-340 \
        i965-va-driver \
        mesa-va-drivers && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install intel-media-va-driver-non-free
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    curl -fsSL "https://repositories.intel.com/graphics/intel-graphics.key" | apt-key add - && \
    echo "deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main" | tee /etc/apt/sources.list.d/intel.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        intel-media-va-driver-non-free && \
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
    echo "deb [arch=amd64] https://repo.jellyfin.org/ubuntu focal main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        jellyfin-server=${VERSION} \
        jellyfin-web \
        jellyfin-ffmpeg && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /
