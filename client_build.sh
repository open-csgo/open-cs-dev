#!/usr/bin/env bash
set -euo pipefail

readonly root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly version=5.18.0
readonly source_dir="$root_dir/client_build/luanti"
readonly build_dir="$root_dir/client_build/build"
readonly install_dir="$root_dir/client_build/install"

for dependency in git cmake ninja c++ pkg-config; do
	if ! command -v "$dependency" >/dev/null 2>&1; then
		printf 'Missing %s. Install the build dependencies listed in README.md.\n' "$dependency" >&2
		exit 1
	fi
done

if [[ ! -e "$source_dir" ]]; then
	mkdir -p -- "$root_dir/client_build"
	git clone --depth 1 --branch "$version" https://github.com/luanti-org/luanti.git "$source_dir"
fi

if [[ ! -d "$source_dir/.git" ]] ||
	! expected_commit=$(git -C "$source_dir" rev-parse --verify "refs/tags/$version^{commit}") ||
	[[ $(git -C "$source_dir" rev-parse HEAD) != "$expected_commit" ]]; then
	printf 'Expected a Luanti %s checkout at %s. Move the existing directory aside and rerun; local work will not be deleted.\n' "$version" "$source_dir" >&2
	exit 1
fi

cmake -S "$source_dir" -B "$build_dir" -G Ninja \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_INSTALL_PREFIX="$install_dir" \
	-DCMAKE_INSTALL_LIBDIR=lib \
	-DRUN_IN_PLACE=FALSE \
	-DBUILD_CLIENT=TRUE \
	-DBUILD_SERVER=FALSE \
	-DBUILD_UNITTESTS=FALSE \
	-DBUILD_BENCHMARKS=FALSE \
	-DBUILD_DOCUMENTATION=FALSE
cmake --build "$build_dir" --parallel "${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}"
cmake --install "$build_dir"

"$install_dir/bin/luanti" --version
printf '\nClient ready. Start the server with docker compose up -d, then run %s/client.sh NAME.\n' "$root_dir"
