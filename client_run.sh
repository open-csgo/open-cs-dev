#!/usr/bin/zsh

if [ -z "$1" ]; then
	echo "\e[1;31mThe script needs a playername as argument\e[1;0m"
	exit 1
else
	if [[ -d "./client_build/minetest/clientmods/open-cs-client" ]]; then
		echo "\e[1;32mLaunching the client\e[1;0m"
		./client_build/minetest/bin/minetest --go --address 0.0.0.0 --name $1 --port 30000 --config ./client_config.conf
	else
		echo "\e[1;31mYou have not linked open-cs-client to ./client_build/minetest/clientmods/open-cs-client\e[1;0m"
		exit 1
	fi
fi