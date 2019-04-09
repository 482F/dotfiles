#!/bin/bash
DFS_DIR=$(cd $(dirname $0); pwd)

ln -s "${DFS_DIR}/.inputrc" ~/.inputrc
ln -s "${DFS_DIR}/.screenrc" ~/.screenrc
ln -s "${DFS_DIR}/.vimrc" ~/.vimrc

grep -E "^source ${DFS_DIR}/.bashrc_bkfiles$" ~/.bashrc

if [ $? -ne 0 ]; then
    echo "source ${DFS_DIR}/.bashrc_bkfiles" >> ~/.bashrc
fi
