#!/bin/bash
set -ue -o pipefail

export LC_ALL=C

DFS_DIR=$(cd $(dirname $0); pwd)
declare -a HOSTNAMES=($(cat "${1}"))
DEPLOY_SH="deploy_to_remote.sh"

for hostname in ${HOSTNAMES[@]}; do
    echo "${hostname}"
    bash "${DEPLOY_SH}" "${hostname}"
done
