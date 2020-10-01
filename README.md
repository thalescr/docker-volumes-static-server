# Docker volumes static server

This is a static files server based on [nginx-unprivileged](https://hub.docker.com/r/nginxinc/nginx-unprivileged) docker image. It is configured to automatically serve all your docker volumes named like `ANYTHING_static` in the URL `http://localhost/ANYTING`.

## Requirements

* A linux environment (for running the scripts)
* Docker >= 19.03.13

## How it works

The `run.sh` script detects all static file volumes and creates configuration files inside `locations/` that will be included into the Nginx configuration file. Then it builds the container and runs it attaching and serving the detected docker volumes.

## Usage

Simply run the bash script:

```sh
./run.sh
```

When stopping the container, plase use `stop.sh` script:

```sh
./stop.sh
```