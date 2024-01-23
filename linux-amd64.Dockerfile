ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8096
ARG DEBIAN_FRONTEND="noninteractive"

# install jellyfin
ARG VERSION
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    curl -fsSL "https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key" | apt-key add - && \
    echo "deb [arch=amd64] https://repo.jellyfin.org/ubuntu jammy main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        ocl-icd-libopencl1 \
        jellyfin-server=${VERSION} \
        jellyfin-web \
        jellyfin-ffmpeg6 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/intel/compute-runtime/releases
ARG INTEL_CR_VERSION
RUN mkdir /tmp/intel-compute-runtime && \
    cd /tmp/intel-compute-runtime && \
    curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/tags/${INTEL_CR_VERSION}" | jq -r '.body' | grep wget | grep -v .sum | grep -v .ddeb | sed 's|wget ||g' > list.txt && \
    wget -i list.txt && \
    dpkg -i *.deb && \
    cd .. && \
    rm -rf /tmp/*

COPY root/ /
