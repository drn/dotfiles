#!/bin/bash

dev="$HOME/Development"
dotfiles="$dev/dotfiles"
mjolnir="$dotfiles/mjolnir"
destination="$HOME/.mjolnir"

# include install functions
source "$dotfiles/install/core.cfg"

# clean up destination directory
sudo rm -rf "$destination"
mkdir -p "$destination"

sudo rm -rf $HOME/.luarocks
mkdir -p $HOME/.luarocks
echo 'rocks_servers = { "http://rocks.moonscript.org" }' > ~/.luarocks/config.lua

luarocks install mjolnir.hotkey
luarocks install mjolnir.application
luarocks install mjolnir.screen

link $mjolnir $destination