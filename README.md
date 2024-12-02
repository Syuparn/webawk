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
$ docker run -it -p 8080:8080 ghcr.io/syuparn/webawk:0.4.2 'GET("/names") { b["names"][1]="Taro"; res(200, b) }'
```

See https://github.com/users/Syuparn/packages/container/package/webawk for detail.

# Usage

See `./examples` for practical examples.
You can also check command options by `./webawk.sh -h`.

```
-f progfile : run program file instead of program string
-h          : get help
-n          : how many requests it can handle (default: 2147483647)
-p port     : port to listen (default: 8080)
-c command  : which awk command to run (default: gawk)

Example:
  webawk.sh 'GET("/names") {b["names"][1]="Taro"; res(200, b)}'
```

# For developers

```bash
# test
$ ./test.sh
```
