#!/bin/bash
set -e
version=$(curl -fsSL "https://repo.jellyfin.org/ubuntu/dists/jammy/main/binary-amd64/Packages" | grep -A 7 -m 1 'Package: jellyfin-server')
version=$(awk -F ': ' '/Version/{print $2;exit}' <<< "${version}")
intel_cr_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -re '.tag_name')
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg intel_cr_version "${intel_cr_version//v/}" \
    '.version = $version | .intel_cr_version = $intel_cr_version' <<< "${json}" | tee VERSION.json
