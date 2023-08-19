ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8096
ARG DEBIAN_FRONTEND="noninteractive"

VOLUME ["${CONFIG_DIR}"]

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
        jellyfin-ffmpeg5 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        wget ocl-icd-libopencl1 && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
# https://github.com/intel/compute-runtime/releases
    mkdir /tmp/intel-compute-runtime && \
    cd /tmp/intel-compute-runtime && \
    RUNTIME_URLS=$(curl -sX GET "https://api.github.com/repos/intel/compute-runtime/releases/tags/$(curl -sX GET "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -r '.tag_name')" | jq -r '.body' | grep wget | grep -v .sum | grep -v .ddeb | sed 's|wget ||g') && \
    for url in ${RUNTIME_URLS}; do \
        wget "${url%$'\r'}"; \
    done \
    dpkg -i *.deb && \
    cd .. && \
    rm -rf /tmp/intel-compute-runtime

COPY root/ /
RUN chmod -R +x /etc/cont-init.d/ /etc/services.d/
