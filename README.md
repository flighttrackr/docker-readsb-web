# Readsb Web

[![Release](https://github.com/flighttrackr/docker-readsb-web/actions/workflows/release.yml/badge.svg)](https://github.com/flighttrackr/docker-readsb-web/actions/workflows/release.yml)

This project makes our own software readsb-web available as a Docker image.

Due to the API limitations of Docker Hub, we use GitHub as container image registry.

## Other projects

We have other Flighttracking projects, check our [GitHub profile].

## Supported architectures

- linux/amd64
- linux/arm/v6
- linux/arm/v7
- linux/arm64
- linux/386

## Run container

```shell
docker run \
  -it --rm \
  ghcr.io/flighttrackr/readsb-web:latest
```

## Environment variables

| Environment variable | Default | Description |
| :- | :- | :- |
| READSB_HOST | readsb | Readsb Hostname/IP address |
| READSB_PORT | 8042 | Readsb HTTP Port |
| PAGE_TITLE | Readsb Web | Webpage title |
| REFRESH_RATE | 250 | Refresh rate in ms |
| CENTER_LAT | 45.0 | Center latitude |
| CENTER_LNG | 9.0 | Center longitude |
| CENTER_RADIUS | 500 | Center radius |


[GitHub profile]: https://github.com/flighttrackr
