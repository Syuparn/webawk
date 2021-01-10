@include "request/main_test.awk"
@include "request/request_line.awk"

BEGIN {
    err = test_parse_request_line()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_parse_request_line(    tests, f) {
    tests[1]["title"]               = "request line1"
    tests[1]["input"]               = "GET /names HTTP/1.1"
    tests[1]["expected"]["method"]  = "GET"
    tests[1]["expected"]["url"]    = "/names"
    tests[1]["expected"]["version"] = "HTTP/1.1"

    for (i in tests) {
        f = test::string_to_stdin(tests[i]["input"])

        err = _test_parse_request_line(tests[i], f)
        test::teardown_fixture(f)
        if (err) {
            return "test_parse_request_line: " err
        }
    }
}

function _test_parse_request_line(tc, f,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    request::parse_request_line(f, actual)

    if (length(actual) != length(tc["expected"])) {
        return sprintf("%s: length must be %d. got=%d",
            log_prefix, length(tc["expected"]), length(actual))
    }

    for (key in tc["expected"]) {
        if (!(key in actual)) {
            return sprintf("%s: key %s must be contained", log_prefix, key)
        }
        if (actual[key] != tc["expected"][key]) {
            return sprintf("%s: header %s must be %s. got=%s",
                log_prefix, key, tc["expected"][key], actual[key])
        }
    }

    return ""
}
