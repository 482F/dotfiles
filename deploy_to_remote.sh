#!/bin/bash
set -ue -o pipefail

export LC_ALL=C

HOSTNAME="${1}"
DFS_DIR=$(cd $(dirname $0); pwd)
DFS_DIR_NAME=$(basename ${DFS_DIR})
DEPLOY_SH="make_link.sh"

rsync -r --delete "${DFS_DIR}" "${HOSTNAME}:~/"
ssh "${HOSTNAME}" "bash ~/${DFS_DIR_NAME}/${DEPLOY_SH}"
