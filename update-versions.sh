#!/bin/bash
set -exuo pipefail

version=$(curl -fsSL "https://repo.jellyfin.org/ubuntu/dists/noble/unstable/binary-amd64/Packages" | grep -A 7 -m 1 'Package: jellyfin-server')
version=$(awk -F ': ' '/Version/{print $2;exit}' <<< "${version}" | sed s/+.*//g)
version_intel_cr=$(curl -fsSL "https://api.github.com/repos/intel/compute-runtime/releases/latest" | jq -re '.tag_name')
json=$(cat meta.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg version_intel_cr "${version_intel_cr//v/}" \
    '.version = $version | .version_intel_cr = $version_intel_cr' <<< "${json}" | tee meta.json
