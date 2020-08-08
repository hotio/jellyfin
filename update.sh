#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    mkdir ~/.docker && echo '{"experimental": "enabled"}' > ~/.docker/config.json
    image="hotio/base"
    tag="bionic"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm" and .platform.os == "linux").digest')   && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-arm-v7.Dockerfile && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
else
    version=$(curl -fsSL "https://repo.jellyfin.org/releases/server/ubuntu/unstable/server/" | grep -o ">jellyfin-server_.*-unstable_amd64.deb<" | sed -e 's/>jellyfin-server_//g' -e 's/-unstable_amd64.deb<//g' | sort -r | head -1)
    [[ -z ${version} ]] && exit 1
    version_web=$(curl -fsSL "https://repo.jellyfin.org/releases/server/ubuntu/unstable/web/" | grep -o ">jellyfin-web_.*-unstable_all.deb<" | sed -e 's/>jellyfin-web_//g' -e 's/-unstable_all.deb<//g' | sort -r | head -1)
    [[ -z ${version_web} ]] && exit 1
    version_ffmpeg=$(curl -fsSL "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/" | grep -o ">jellyfin-ffmpeg_.*-bionic_amd64.deb<" | sed -e 's/>jellyfin-ffmpeg_//g' -e 's/-bionic_amd64.deb<//g')
    [[ -z ${version_ffmpeg} ]] && exit 1
    sed -i "s/{JELLYFIN_VERSION=[^}]*}/{JELLYFIN_VERSION=${version}}/g" .github/workflows/build.yml
    sed -i "s/{JELLYFIN_WEB_VERSION=[^}]*}/{JELLYFIN_WEB_VERSION=${version_web}}/g" .github/workflows/build.yml
    sed -i "s/{FFMPEG_VERSION=[^}]*}/{FFMPEG_VERSION=${version_ffmpeg}}/g" .github/workflows/build.yml
    version="${version}/${version_web}/${version_ffmpeg}"
    echo "##[set-output name=version;]${version}"
fi

