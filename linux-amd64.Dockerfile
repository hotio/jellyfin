ARG UPSTREAM_IMAGE
ARG UPSTREAM_TAG_SHA

FROM ${UPSTREAM_IMAGE}:${UPSTREAM_TAG_SHA}
EXPOSE 8096
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8096/tcp" MALLOC_TRIM_THRESHOLD_=131072

ARG DEBIAN_FRONTEND="noninteractive"
# install jellyfin
ARG VERSION
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    curl -fsSL "https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key" | apt-key add - && \
    echo "deb [arch=amd64] https://repo.jellyfin.org/ubuntu noble main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    echo "deb [arch=amd64] https://repo.jellyfin.org/ubuntu noble unstable" | tee -a /etc/apt/sources.list.d/jellyfin.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libjemalloc2 && \
    mkdir -p /usr/lib/jellyfin && ln -s /usr/lib/x86_64-linux-gnu/libjemalloc.so.2 /usr/lib/jellyfin/libjemalloc.so.2 && \
    apt install -y --no-install-recommends --no-install-suggests \
        ocl-icd-libopencl1 \
        jellyfin-server=${VERSION}+ubu2404 \
        jellyfin-web \
        jellyfin-ffmpeg7 && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV LD_PRELOAD="/usr/lib/jellyfin/libjemalloc.so.2"

# https://github.com/intel/compute-runtime/releases
ARG INTEL_CR_VERSION
RUN mkdir /tmp/intel-compute-runtime && \
    cd /tmp/intel-compute-runtime && \
    curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/tags/${INTEL_CR_VERSION}" | jq -r '.assets[].browser_download_url' | grep -e "libigdgmm.*\.deb" >> list.txt && \
    curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/tags/${INTEL_CR_VERSION}" | jq -r '.assets[].browser_download_url' | grep -e "intel-opencl-icd.*\.deb" >> list.txt && \
    curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/tags/${INTEL_CR_VERSION}" | jq -r '.body' | grep "wget" | grep "intel-graphics-compiler" | sed 's|wget ||g' >> list.txt && \
    echo "https://github.com/intel/compute-runtime/releases/download/24.35.30872.22/intel-opencl-icd-legacy1_24.35.30872.22_amd64.deb" >> list.txt && \
    echo "https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17537.20/intel-igc-core_1.0.17537.20_amd64.deb" >> list.txt && \
    echo "https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17537.20/intel-igc-opencl_1.0.17537.20_amd64.deb" >> list.txt && \
    wget -i list.txt && \
    dpkg -i *.deb && \
    cd .. && \
    rm -rf /tmp/*

COPY root/ /
RUN find /etc/s6-overlay/s6-rc.d -name "run*" -execdir chmod +x {} +
