@include "response/response.awk"

BEGIN {
    err = test_response_lines()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_response_lines(    tests) {
    tests[1]["title"]                 = "empty body"
    tests[1]["status_code"]           = 204
    tests[1]["headers"]["Connection"] = "keep-alive"
    tests[1]["body"]                  = ""
    tests[1]["expected"]              =\
        "HTTP/1.1 204 No Content\r\n"\
        "Connection: keep-alive\r\n"

    tests[2]["title"]                     = "with body"
    tests[2]["status_code"]               = 200
    tests[2]["headers"]["Content-Type"]   = "application/json"
    tests[2]["headers"]["Content-Length"] = 16
    tests[2]["body"]                      = "{\"name\": \"Taro\"}"
    tests[2]["expected"]                  =\
        "HTTP/1.1 200 OK\r\n"\
        "Content-Length: 16\r\n"\
        "Content-Type: application/json\r\n"\
        "{\"name\": \"Taro\"}"

    for (i in tests) {
        err = _test_response_lines(tests[i])
        if (err) {
            return "test_response_lines: " err
        }
    }
}

function _test_response_lines(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = response::response_lines(tc["status_code"], tc["headers"], tc["body"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '\n%s'. got='\n%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
