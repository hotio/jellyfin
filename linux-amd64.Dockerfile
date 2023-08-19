ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8096
ARG DEBIAN_FRONTEND="noninteractive"

VOLUME ["${CONFIG_DIR}"]

RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        wget ocl-icd-libopencl1 && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/intel/compute-runtime/releases
ARG GMMLIB_VERSION=22.0.2
ARG IGC_VERSION=1.0.10395
ARG NEO_VERSION=22.08.22549
ARG LEVEL_ZERO_VERSION=1.3.22549

RUN mkdir /tmp/intel-compute-runtime && \
    cd /tmp/intel-compute-runtime && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.14062.11/intel-igc-core_1.0.14062.11_amd64.deb && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.14062.11/intel-igc-opencl_1.0.14062.11_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/23.22.26516.18/intel-level-zero-gpu_1.3.26516.18_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/23.22.26516.18/intel-opencl-icd_23.22.26516.18_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/23.22.26516.18/libigdgmm12_22.3.0_amd64.deb && \
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
