@include "server/globalvars.awk"
@include "server/reset.awk"

BEGIN {
    err = test_reset_globals()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_reset_globals(    tests) {
    HTTP_VERSION = "http/1.1"
    HTTP_METHOD = "PUT"
    REQUEST_PATH = "/names/taro/articles/2"

    REQUEST_HEADERS["Content-Type"] = "application/json"
    REQUEST_HEADERS["Content-Length"] = 15

    REQUEST_QUERIES["tag"][1] = "language"
    REQUEST_QUERIES["tag"][2] = "web"
    REQUEST_QUERIES["limit"][1] = 100

    REQUEST_PATHPARAMS["name"] = "Taro"
    REQUEST_PATHPARAMS["article"] = 2

    REQUEST_BODY = "{\"title\":\"awk\"}"

    _RESPONDED = 1

    err = _test_reset_globals()
    if (err) {
        return "test_reset_globals: " err
    }
}

function _test_reset_globals() {
    log_prefix = "all variables are set"
    server::reset_globals()

    if (HTTP_VERSION != "") {
        return sprintf("%s: HTTP_VERSION must be empty. got='%s'",
            log_prefix, HTTP_VERSION)
    }

    if (HTTP_METHOD != "") {
        return sprintf("%s: HTTP_METHOD must be empty. got='%s'",
            log_prefix, HTTP_METHOD)
    }

    if (REQUEST_PATH != "") {
        return sprintf("%s: HTTP_METHOD must be empty. got='%s'",
            log_prefix, REQUEST_PATH)
    }

    if (length(REQUEST_QUERIES)) {
        return sprintf("%s: REQUEST_QUERIES length must be 0. got='%s'",
            log_prefix, length(REQUEST_QUERIES))
    }

    if (length(REQUEST_PATHPARAMS)) {
        return sprintf("%s: REQUEST_PATHPARAMS length must be 0. got='%s'",
            log_prefix, length(REQUEST_PATHPARAMS))
    }

    if (length(REQUEST_HEADERS)) {
        return sprintf("%s: REQUEST_HEADERS length must be 0. got='%s'",
            log_prefix, length(REQUEST_HEADERS))
    }

    if (REQUEST_BODY != "") {
        return sprintf("%s: REQUEST_BODY must be empty. got='%s'",
            log_prefix, REQUEST_BODY)
    }

    if (_RESPONDED != 0) {
        return sprintf("%s: _RESPONDED must be empty. got='%s'",
            log_prefix, _RESPONDED)
    }
}
