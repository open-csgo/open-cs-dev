# Open CS development

Docker server and native Linux client, both pinned to **Luanti 5.18.0**.

## Setup

Requires Linux, Docker Compose, Git, Bash, CMake 3.15+, Ninja, and the [Luanti build dependencies](https://github.com/luanti-org/luanti/blob/5.18.0/doc/compiling/linux.md), including libzip.

Clone the three repositories beside each other:

```sh
git clone --recurse-submodules https://github.com/open-csgo/open-cs.git
git clone https://github.com/open-csgo/open-cs-client.git
git clone https://github.com/open-csgo/open-cs-dev.git
cd open-cs-dev

docker compose up -d
./client_build.sh
./client.sh alice
```

`alice` is both the username and password. Run `./client.sh bob` for another client. Each player gets a separate profile and log at `.clients/NAME/`.

## Development

```sh
docker compose logs -f server   # Server logs
docker compose restart server   # Reload game or server configuration changes
docker compose down             # Stop the server, keeping its data
./client_build.sh               # Rebuild the pinned client engine
```

Restart the client after editing `open-cs-client`; no engine rebuild is needed. To limit build memory usage, use `CMAKE_BUILD_PARALLEL_LEVEL=2 ./client_build.sh`.

Server data lives in the `server-data` Docker volume. **`docker compose down --volumes` deletes it**, including accounts.

## Connection settings

The server is local-only by default. These environment variables override the connection:

| Variable | Default | Purpose |
| --- | --- | --- |
| `OPEN_CS_ADDRESS` | `127.0.0.1` | Client destination |
| `OPEN_CS_PORT` | `30000` | Host port; set for both server and client |
| `OPEN_CS_BIND_ADDRESS` | `127.0.0.1` | Server interface; use `0.0.0.0` for LAN access |

Use name-as-password accounts only for development on trusted networks.
