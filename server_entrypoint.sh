#!/bin/sh
set -eu

world=/var/lib/minetest/world
mkdir -p "$world"
for file in world.mt map_meta.txt; do
	if [ ! -e "$world/$file" ]; then
		cp "/opt/open-cs/world-template/$file" "$world/$file"
	fi
done

exec /usr/local/bin/luantiserver \
	--config /etc/minetest/minetest.conf \
	--gameid open-cs --world "$world" --logfile "" "$@"
