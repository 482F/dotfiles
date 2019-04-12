#!/bin/bash
DFS_DIR=$(cd $(dirname $0); pwd)
declare -a BLACK_LIST=(
".git"
".gitignore"
".bashrc_dotfiles"
)

cd "${DFS_DIR}"

for f in .??*; do
    if `echo ${BLACK_LIST[@]} | grep -q "${f}"`; then
        continue
    fi
    if [ -e "${HOME}/${f}" ]; then
        continue
    fi
    ln -s "${DFS_DIR}/${f}" "${HOME}/${f}"
done

find "${HOME}/" -xtype l | xargs --no-run-if-empty rm

grep -E "^source ${DFS_DIR}/.bashrc_dotfiles$" ~/.bashrc

if [ $? -ne 0 ]; then
    echo "source ${DFS_DIR}/.bashrc_dotfiles" >> ~/.bashrc
fi
