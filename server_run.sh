#!/usr/bin/zsh

if [[ -f "./server_build/minetest/games/open-cs" ]] then
    ./server_build/minetest/bin/minetestserver --gameid open-cs --world ./server_world --config ./server_config.conf
else
	echo "You have not linked open-cs to ./server_build/minetest/games/open-cs"
	exit 1
fi