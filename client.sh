#!/usr/bin/env bash
set -euo pipefail

readonly root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# != 1 ]] || [[ ! $1 =~ ^[A-Za-z0-9_-]+$ ]]; then
	printf 'Usage: %s NAME\nNAME may contain only letters, digits, underscores, and hyphens.\n' "${0##*/}" >&2
	exit 1
fi

readonly name=$1
readonly binary="$root_dir/client_build/install/bin/luanti"
readonly mod_dir="$(dirname -- "$root_dir")/open-cs-client"
readonly profile="$root_dir/.clients/$name"
readonly address="${OPEN_CS_ADDRESS:-127.0.0.1}"
readonly port="${OPEN_CS_PORT:-30000}"

if [[ ! -x "$binary" ]]; then
	printf 'Client build missing. Run %s/client_build.sh first.\n' "$root_dir" >&2
	exit 1
fi
if [[ ! -f "$mod_dir/init.lua" || ! -f "$mod_dir/mod.conf" ]]; then
	printf 'Client mod missing at %s. Clone open-cs-client beside open-cs-dev as described in README.md.\n' "$mod_dir" >&2
	exit 1
fi
if [[ ! $port =~ ^[0-9]{1,5}$ ]] || (( 10#$port < 1 || 10#$port > 65535 )); then
	printf 'OPEN_CS_PORT must be an integer between 1 and 65535.\n' >&2
	exit 1
fi
version=$("$binary" --version)
if [[ ! $version =~ ^Luanti[[:space:]]5\.18\.0([[:space:]]|$) ]]; then
	printf 'Expected Luanti 5.18.0. Rebuild using %s/client_build.sh.\n' "$root_dir" >&2
	exit 1
fi

mkdir -p -- "$profile/clientmods" "$profile/.cache"
if [[ ! -e "$profile/minetest.conf" ]]; then
	cp -- "$root_dir/client_config.conf" "$profile/minetest.conf"
fi
for setting in enable_client_modding enable_mod_channels; do
	if grep -qE "^[[:space:]]*$setting[[:space:]]*=" "$profile/minetest.conf"; then
		sed -i -E "s/^[[:space:]]*$setting[[:space:]]*=.*/$setting = true/" "$profile/minetest.conf"
	else
		printf '\n%s = true\n' "$setting" >> "$profile/minetest.conf"
	fi
done

readonly mod_link="$profile/clientmods/open_cs_client"
if [[ -e "$mod_link" && ! -L "$mod_link" ]]; then
	printf 'Cannot link the client mod: %s already exists and is not a symlink. Move it aside and rerun.\n' "$mod_link" >&2
	exit 1
fi
ln -sfn -- "$mod_dir" "$mod_link"
printf 'load_mod_open_cs_client = true\n' > "$profile/clientmods/mods.conf"

printf 'Connecting %s to %s:%s (profile: %s).\n' "$name" "$address" "$port" "$profile"
export LUANTI_USER_PATH="$profile"
export XDG_CACHE_HOME="$profile/.cache"
exec "$binary" --go --address "$address" --port "$port" \
	--name "$name" --password "$name" \
	--config "$profile/minetest.conf" --logfile "$profile/debug.txt"
