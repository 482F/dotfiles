#!/bin/bash
set -ue -o pipefail

export LC_ALL=C

DFS_DIR=$(cd $(dirname $0); pwd)
declare -a BLACK_LIST=(
".git"
".gitignore"
".bashrc_dotfiles"
".config"
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

if ! grep -qE "^source ${DFS_DIR}/.bashrc_dotfiles$" ~/.bashrc; then
    echo "source ${DFS_DIR}/.bashrc_dotfiles" >> ~/.bashrc
fi

perl -pi -e 's|^((export )?HISTSIZE)|#$1|' ~/.bashrc
perl -pi -e 's|^((export )?HISTFILESIZE)|#$1|' ~/.bashrc
perl -pi -e 's|^((export )?HISTIGNORE)|#$1|' ~/.bashrc
