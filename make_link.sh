#!/bin/bash
DFS_DIR=$(cd $(dirname $0); pwd)

ln -s "${DFS_DIR}/.inputrc" ~/.inputrc
ln -s "${DFS_DIR}/.screenrc" ~/.screenrc
ln -s "${DFS_DIR}/.vimrc" ~/.vimrc
ln -s "${DFS_DIR}/.vim" ~/.vim

grep -E "^source ${DFS_DIR}/.bashrc_dotfiles$" ~/.bashrc

if [ $? -ne 0 ]; then
    echo "source ${DFS_DIR}/.bashrc_dotfiles" >> ~/.bashrc
fi
