@include "response/header.awk"

BEGIN {
    err = test_header_lines()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_header_lines(    tests) {
    tests[1]["title"]                   = "1 header"
    tests[1]["headers"]["Content-Type"] = "application/json"
    tests[1]["expected"]                = "Content-Type: application/json\r\n"

    # sorted alphabetically
    tests[2]["title"]                     = "2 headers"
    tests[2]["headers"]["Content-Type"]   = "application/json"
    tests[2]["headers"]["Content-Length"] = 10
    tests[2]["expected"]                  =\
        "Content-Length: 10\r\n"\
        "Content-Type: application/json\r\n"

    tests[3]["title"]       = "no headers"
    # init empty array
    tests[3]["headers"][""] = ""
    delete tests[3]["headers"][""]
    tests[3]["expected"]    = ""

    for (i in tests) {
        err = _test_header_lines(tests[i])
        if (err) {
            return "test_header_lines: " err
        }
    }
}

function _test_header_lines(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = response::header_lines(tc["headers"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '\n%s'. got='\n%s'", 
            log_prefix, tc["expected"], actual)
    }

    return ""
}
