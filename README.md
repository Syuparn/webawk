# webawk
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

# Usage

See `./examples` for practical examples.
You can also check command options by `./webawk.sh -h`.
