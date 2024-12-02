# webawk
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Test](https://github.com/Syuparn/webawk/actions/workflows/test.yaml/badge.svg)](https://github.com/Syuparn/webawk/actions/workflows/test.yaml)

simple (mock) web server framework written in awk

# What's this?

Webawk is a simple JSON API server framework for awk.
This helps to make dummy-response server by only awk one-line command.

```bash
$ ./webawk.sh 'GET("/names") { b["names"][1]="Taro"; res(200, b) }'
```

```bash
$ curl localhost:8080/names
{"names":["Taro"]}
```

# Requirement

- GNU awk (5.x.x+)
    - should be installed as `gawk`
- jq
    - because I have not written a JSON parser yet :smirk:

# Image

Or you can run webawk docker image.

```bash
$ docker pull ghcr.io/syuparn/webawk:0.3.0
```

See https://github.com/users/Syuparn/packages/container/package/webawk for detail.

# Usage

See `./examples` for practical examples.
You can also check command options by `./webawk.sh -h`.

# For developers

```bash
# test
$ ./test.sh
```
