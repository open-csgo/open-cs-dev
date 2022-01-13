#!/usr/bin/zsh

# https://unix.stackexchange.com/questions/363143/output-in-color-bash

if [[ -d "./server_build/minetest/games/open-cs" ]] then
	echo "\e[1;32mLaunching the server\e[1;0m"
    ./server_build/minetest/bin/minetestserver --gameid open-cs --world ./server_world --config ./server_config.conf
else
	echo "\e[1;31mYou have not linked open-cs to ./server_build/minetest/games/open-cs\e[1;0m"
	exit 1
fi