@include "response/response_line.awk"

BEGIN {
    err = test_response_line()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_response_line(    tests) {
    tests[1]["title"]       = "OK"
    tests[1]["status_code"] = 200
    tests[1]["expected"]    = "HTTP/1.1 200 OK"

    tests[2]["title"]       = "Not Found"
    tests[2]["status_code"] = 404
    tests[2]["expected"]    = "HTTP/1.1 404 Not Found"

    for (i in tests) {
        err = _test_response_line(tests[i])
        if (err) {
            return "test_response_line: " err
        }
    }
}

function _test_response_line(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = response::response_line(tc["status_code"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
