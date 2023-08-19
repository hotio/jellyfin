ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8096
ARG DEBIAN_FRONTEND="noninteractive"

VOLUME ["${CONFIG_DIR}"]

# https://github.com/intel/compute-runtime/releases
ARG GMMLIB_VERSION=22.0.2
ARG IGC_VERSION=1.0.10395
ARG NEO_VERSION=22.08.22549
ARG LEVEL_ZERO_VERSION=1.3.22549

RUN mkdir /tmp/intel-compute-runtime && \
    cd /tmp/intel-compute-runtime && \
    wget "https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-gmmlib_${GMMLIB_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-core_${IGC_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-opencl_${IGC_VERSION}_amd64.deb" && \
    wget "https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-opencl-icd_${NEO_VERSION}_amd64.deb "&& \
    wget "https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-level-zero-gpu_${LEVEL_ZERO_VERSION}_amd64.deb" && \
    dpkg -i *.deb && \
    cd .. && \
    rm -rf /tmp/intel-compute-runtime

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

COPY root/ /
RUN chmod -R +x /etc/cont-init.d/ /etc/services.d/
