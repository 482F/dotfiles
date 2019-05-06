#!/bin/bash
DFS_DIR=$(cd $(dirname $0); pwd)
declare -a BLACK_LIST=(
".git"
".gitignore"
".bashrc_dotfiles"
)

cd "${DFS_DIR}"

echo "${DFS_DIR}"

find "${HOME}/" -xtype l | xargs --no-run-if-empty rm

sed -i -e "s%^source ${DFS_DIR}/.bashrc_dotfiles$%%g" ~/.bashrc
