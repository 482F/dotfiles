#!/bin/bash
DFS_DIR=$(cd $(dirname $0); pwd)
declare -a BLACK_LIST=(
".git"
".gitignore"
)

for f in .??*; do
    if `echo ${array[@]} | grep -q "${f}"; then
        continue
    fi
    ln -s "${DFS_DIR}/${f}" "${HOME}/${f}"
done

grep -E "^source ${DFS_DIR}/.bashrc_dotfiles$" ~/.bashrc

if [ $? -ne 0 ]; then
    echo "source ${DFS_DIR}/.bashrc_dotfiles" >> ~/.bashrc
fi
