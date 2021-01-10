@include "request/main_test.awk"
@include "request/request.awk"

BEGIN {
    err = test_parse_request()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_parse_request(    tests) {
    tests[1]["title"]                   = "simple request"
    tests[1]["fixturename"]             = "request_simple.txt"
    tests[1]["expected"]["version"]     = "HTTP/1.1"
    tests[1]["expected"]["method"]      = "GET"
    tests[1]["expected"]["path"]        = "/names"
    # no request headers
    tests[1]["expected"]["headers"][""] = ""
    delete tests[1]["expected"]["headers"][""]
    # no query parameters
    tests[1]["expected"]["queries"][""] = ""
    delete tests[1]["expected"]["queries"][""]
    # no body
    tests[1]["expected"]["body"]        = ""

    tests[2]["title"]                             = "request with header"
    tests[2]["fixturename"]                       = "request_with_header.txt"
    tests[2]["expected"]["version"]               = "HTTP/1.1"
    tests[2]["expected"]["method"]                = "GET"
    tests[2]["expected"]["path"]                  = "/names"
    tests[2]["expected"]["headers"]["Connection"] = "keep-alive"
    tests[2]["expected"]["headers"]["Host"]       = "example.com"
    # no query parameters
    tests[2]["expected"]["queries"][""]           = ""
    delete tests[2]["expected"]["queries"][""]
    # no body
    tests[2]["expected"]["body"]                  = ""

    tests[3]["title"]                                 = "request with body"
    tests[3]["fixturename"]                           = "request_with_body.txt"
    tests[3]["expected"]["version"]                   = "HTTP/1.1"
    tests[3]["expected"]["method"]                    = "POST"
    tests[3]["expected"]["path"]                      = "/languages"
    tests[3]["expected"]["headers"]["Content-Length"] = 15
    tests[3]["expected"]["headers"]["Content-Type"]   = "application/json"
    # no query parameters
    tests[3]["expected"]["queries"][""]               = ""
    delete tests[3]["expected"]["queries"][""]
    tests[3]["expected"]["body"]                      = "{\"name\": \"AWK\"}"

    tests[4]["title"]                                 = "request with query parameters"
    tests[4]["fixturename"]                           = "request_with_query.txt"
    tests[4]["expected"]["version"]                   = "HTTP/1.1"
    tests[4]["expected"]["method"]                    = "GET"
    tests[4]["expected"]["path"]                      = "/articles"
    # no request headers
    tests[4]["expected"]["headers"][""] = ""
    delete tests[4]["expected"]["headers"][""]
    # no query parameters
    tests[4]["expected"]["queries"]["page"][1]        = "1"
    tests[4]["expected"]["queries"]["tag"][1]         = "awk"
    tests[4]["expected"]["queries"]["tag"][2]         = "web"
    tests[4]["expected"]["body"]                      = ""

    for (i in tests) {
        f = test::setup_fixture(tests[i]["fixturename"])
        err = _test_parse_request(tests[i], f)
        test::teardown_fixture(f)
        if (err) {
            return "test_parse_request: " err
        }
    }
}

function _test_parse_request(tc, f,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    request::parse_request(f, actual)

    if (actual["version"] != tc["expected"]["version"]) {
        return sprintf("%s: version must be '%s'. got='%s'",
            log_prefix, tc["expected"]["version"], actual["version"])
    }

    if (actual["method"] != tc["expected"]["method"]) {
        return sprintf("%s: method must be '%s'. got='%s'",
            log_prefix, tc["expected"]["method"], actual["method"])
    }

    if (actual["path"] != tc["expected"]["path"]) {
        return sprintf("%s: path must be '%s'. got='%s'",
            log_prefix, tc["expected"]["path"], actual["path"])
    }

    err = _test_headers(tc, f, actual["headers"])
    if (err) {
        return sprintf("%s: %s", log_prefix, err)
    }

    err = _test_queries(tc, f, actual["queries"])
    if (err) {
        return sprintf("%s: %s", log_prefix, err)
    }

    if (actual["body"] != tc["expected"]["body"]) {
        return sprintf("%s: body must be '%s'. got='%s'",
            log_prefix, tc["expected"]["body"], actual["body"])
    }

    return ""
}

function _test_headers(tc, f, actual){
    if (length(actual) != length(tc["expected"]["headers"])) {
        return sprintf("headers length must be %d. got=%d",
            length(tc["expected"]["headers"]), length(actual))
    }

    for (name in tc["expected"]["headers"]) {
        if (!(name in actual)) {
            return sprintf("header %s must be contained", name)
        }
        if (actual[name] != tc["expected"]["headers"][name]) {
            return sprintf("header %s must be %s. got=%s",
                name, tc["expected"][name], headers[name])
        }
    }

    return ""
}

function _test_queries(tc, f, actual){
    if (length(actual) != length(tc["expected"]["queries"])) {
        return sprintf("queries length must be %d. got=%d",
            length(tc["expected"]["queries"]), length(actual))
    }

    for (name in tc["expected"]["queries"]) {
        if (!(name in actual)) {
            return sprintf("query %s must be contained", name)
        }

        if (length(actual[name]) != length(tc["expected"]["queries"][name])) {
        return sprintf("%s: length of actual[%s] must be %d. got=%d",
            log_prefix, name, length(tc["expected"]["queries"][name]), length(actual[name]))
        }

        for (i in tc["expected"]["queries"][name]) {
            if (actual[name][i] != tc["expected"]["queries"][name][i]) {
                return sprintf("%s: actual[%s][%d] must be %s. got=%s",
                    log_prefix, name, i, tc["expected"]["queries"][name][i], actual[name][i])
            }
        }
    }

    return ""
}
