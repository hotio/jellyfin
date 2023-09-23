#!/bin/bash

#version=$(curl -fsSL "https://repo.jellyfin.org/releases/server/ubuntu/stable/server/" | grep -o ">jellyfin-server_.*_arm64.deb<" | sed -e 's/>jellyfin-server_//g' -e 's/_arm64.deb<//g' | sort -r | head -1)
version=$(curl -fsSL "https://repo.jellyfin.org/ubuntu/dists/jammy/main/binary-amd64/Packages" | grep -A 7 -m 1 'Package: jellyfin-server' | awk -F ': ' '/Version/{print $2;exit}')
[[ -z ${version} ]] && exit 0
intel_cr_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -r '.tag_name')
[[ -z ${intel_cr_version} ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'"' <<< "${version_json}" > VERSION.json
version_json=$(cat ./VERSION.json)
jq '.intel_cr_version = "'"${intel_cr_version}"'"' <<< "${version_json}" > VERSION.json
