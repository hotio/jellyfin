# jellyfin

<img src="https://raw.githubusercontent.com/hotio/docker-jellyfin/master/img/jellyfin.png" alt="Logo" height="130" width="130">

![Base](https://img.shields.io/badge/base-ubuntu-orange)
[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-jellyfin)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/jellyfin)](https://hub.docker.com/r/hotio/jellyfin)
[![GitHub Registry](https://img.shields.io/badge/registry-ghcr.io-blue)](https://github.com/users/hotio/packages/container/jellyfin/versions)
[![Discord](https://img.shields.io/discord/610068305893523457?color=738ad6&label=discord&logo=discord&logoColor=white)](https://discord.gg/3SnkuKp)
[![Upstream](https://img.shields.io/badge/upstream-project-yellow)](https://github.com/jellyfin/jellyfin)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm --name jellyfin -p 8096:8096 -v /<host_folder_config>:/config hotio/jellyfin
```

The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=002
-e TZ="Etc/UTC"
-e ARGS=""
-e DEBUG="no"
```

## Tags

| Tag                  | Description                      |
| ---------------------|----------------------------------|
| latest               | The same as `stable`             |
| stable               | Stable version                   |
| unstable             | Unstable version, nightly builds |

You can also find tags that reference a commit or version number.

## Configuration location

Your jellyfin configuration inside the container is stored in `/config/app`, to migrate from another container, you'd probably have to move your files from `/config` to `/config/app`. The following jellyfin path locations are used by default.

```shell
JELLYFIN_CONFIG_DIR="/config/app"
JELLYFIN_DATA_DIR="/config/app/data"
JELLYFIN_LOG_DIR="/config/app/log"
JELLYFIN_CACHE_DIR="/config/app/cache"
```

You can override these locations by setting them to a different value with a docker environment variable.

## Hardware support

To make your hardware devices available inside the container use the following argument `--device=/dev/dri:/dev/dri` for Intel QuickSync and `--device=/dev/dvb:/dev/dvb` for a tuner. NVIDIA users should go visit the [NVIDIA github](https://github.com/NVIDIA/nvidia-docker) page for instructions. For Raspberry Pi OpenMAX you'll need to use `--device=/dev/vchiq:/dev/vchiq -v /opt/vc/lib:/opt/vc/lib`, V4L2 will need `--device=/dev/video10:/dev/video10 --device=/dev/video11:/dev/video11 --device=/dev/video12:/dev/video12` and MMAL needs `--device=/dev/vcsm:/dev/vcsm` or `--device=/dev/vc-mem:/dev/vc-mem`.

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```

## Troubleshooting a problem

By default all output is redirected to `/dev/null`, so you won't see anything from the application when using `docker logs`. Most applications write everything to a log file too. If you do want to see this output with `docker logs`, you can use `-e DEBUG="yes"` to enable this.
