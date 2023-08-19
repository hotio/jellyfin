#!/bin/bash

version=$(curl -fsSL "https://repo.jellyfin.org/releases/server/ubuntu/unstable/server/" | grep -o ">jellyfin-server_.*_arm64.deb<" | sed -e 's/>jellyfin-server_//g' -e 's/-unstable_arm64.deb<//g' | sort -r | head -1)
[[ -z ${version} ]] && exit 0
intel_cr_version=$(curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -r '.tag_name')
[[ -z ${intel_cr_version} ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'"' <<< "${version_json}" > VERSION.json
jq '.intel_cr_version = "'"${intel_cr_version}"'"' <<< "${version_json}" > VERSION.json
