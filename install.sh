#!/bin/bash

# directory in which this script is located
__file__="$(readlink -f ${BASH_SOURCE[0]})"
__dir__="$(dirname $__file__)"

cd $HOME

# Bash
if [ -L ".bashrc" ]; then rm -fv .bashrc; else [ -e ".bashrc" ] && mv .bashrc .bashrc.old; fi
ln -vs $__dir__/.bashrc


# Git
if [ -L ".gitconfig" ]; then rm -fv .gitconfig; else [ -e ".gitconfig" ] && mv .gitconfig .gitconfig.old; fi
ln -vs $__dir__/.gitconfig


# Vim
if [ -L ".vimrc" ]; then rm -fv .vimrc; else [ -e ".vimrc" ] && mv .vimrc .vimrc.old; fi
ln -vs $__dir__/.vimrc

[ -d ".vim" ] &&  [ ! -L ".vim" ] && mv .vim .vim.old
[ -L ".vim" ] && rm -fv .vim
ln -vs $__dir__/.vim


# Virtual environments (Python)
[ ! -d ".virtualenvs/" ] && mkdir .virtalenvs/
# Remove existing postactive hook
if [ -L ".virtualenvs/postactivate" ]; then
    rm -fv .virtualenvs/postactivate
else
    [ -e ".virtualenvs/postactivate" ] && mv .virtualenvs/postactivate .virtualenvs/postactivate.old
fi
ln -vs $__dir__/.virtualenv/postactivate .virtalenvs/

[ ! -d ".config" ] && mkdir -p .config/
[ -d ".config/terminator" ] &&  [ ! -L ".config/terminator" ] && mv .config/terminator .config/terminator.old
[ -L ".config/terminator" ] && rm -fv .config/terminator
ln -vs $__dir__/terminator .config/
