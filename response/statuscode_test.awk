@include "response/statuscode.awk"

BEGIN {
    err = test_status_text()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_status_text(    tests) {
    # NOTE: set test case indices to status code
    #       not to re-index them when a new code will be defined
    tests[100]["input"]    = 100
    tests[100]["expected"] = "Continue"

    tests[101]["input"]    = 101
    tests[101]["expected"] = "Switching Protocol"

    tests[103]["input"]    = 103
    tests[103]["expected"] = "Early Hints"

    tests[200]["input"]    = 200
    tests[200]["expected"] = "OK"

    tests[201]["input"]    = 201
    tests[201]["expected"] = "Created"

    tests[202]["input"]    = 202
    tests[202]["expected"] = "Accepted"

    tests[203]["input"]    = 203
    tests[203]["expected"] = "Non-Authoritative Information"

    tests[204]["input"]    = 204
    tests[204]["expected"] = "No Content"

    tests[205]["input"]    = 205
    tests[205]["expected"] = "Reset Content"

    tests[300]["input"]    = 300
    tests[300]["expected"] = "Multiple Choices"

    tests[301]["input"]    = 301
    tests[301]["expected"] = "Moved Permanently"

    tests[302]["input"]    = 302
    tests[302]["expected"] = "Found"

    tests[303]["input"]    = 303
    tests[303]["expected"] = "See Other"

    tests[307]["input"]    = 307
    tests[307]["expected"] = "Temporary Redirect"

    tests[308]["input"]    = 308
    tests[308]["expected"] = "Permanent Redirect"

    tests[400]["input"]    = 400
    tests[400]["expected"] = "Bad Request"

    tests[401]["input"]    = 401
    tests[401]["expected"] = "Unauthorized"

    tests[402]["input"]    = 402
    tests[402]["expected"] = "Payment Required"

    tests[403]["input"]    = 403
    tests[403]["expected"] = "Forbidden"

    tests[404]["input"]    = 404
    tests[404]["expected"] = "Not Found"

    tests[405]["input"]    = 405
    tests[405]["expected"] = "Method Not Allowed"

    tests[406]["input"]    = 406
    tests[406]["expected"] = "Not Acceptable"

    tests[407]["input"]    = 407
    tests[407]["expected"] = "Proxy Authentication Required"

    tests[408]["input"]    = 408
    tests[408]["expected"] = "Request Timeout"

    tests[409]["input"]    = 409
    tests[409]["expected"] = "Conflict"

    tests[410]["input"]    = 410
    tests[410]["expected"] = "Gone"

    tests[411]["input"]    = 411
    tests[411]["expected"] = "Length Required"

    tests[412]["input"]    = 412
    tests[412]["expected"] = "Precondition Failed"

    tests[413]["input"]    = 413
    tests[413]["expected"] = "Payload Too Large"

    tests[414]["input"]    = 414
    tests[414]["expected"] = "URI Too Long"

    tests[415]["input"]    = 415
    tests[415]["expected"] = "Unsupported Media Type"

    tests[416]["input"]    = 416
    tests[416]["expected"] = "Range Not Satisfiable"

    tests[417]["input"]    = 417
    tests[417]["expected"] = "Expectation Failed"

    tests[418]["input"]    = 418
    tests[418]["expected"] = "I'm a teapot"

    tests[421]["input"]    = 421
    tests[421]["expected"] = "Misdirected Request"

    tests[425]["input"]    = 425
    tests[425]["expected"] = "Too Early"

    tests[426]["input"]    = 426
    tests[426]["expected"] = "Upgrade Required"

    tests[428]["input"]    = 428
    tests[428]["expected"] = "Precondition Required"

    tests[429]["input"]    = 429
    tests[429]["expected"] = "Too Many Requests"

    tests[431]["input"]    = 431
    tests[431]["expected"] = "Request Header Fields Too Large"

    tests[451]["input"]    = 451
    tests[451]["expected"] = "Unavailable For Legal Reasons"

    tests[500]["input"]    = 500
    tests[500]["expected"] = "Internal Server Error"

    tests[501]["input"]    = 501
    tests[501]["expected"] = "Not Implemented"

    tests[502]["input"]    = 502
    tests[502]["expected"] = "Bad Gateway"

    tests[503]["input"]    = 503
    tests[503]["expected"] = "Service Unavailable"

    tests[504]["input"]    = 504
    tests[504]["expected"] = "Gateway Timeout"

    tests[505]["input"]    = 505
    tests[505]["expected"] = "HTTP Version Not Supported"

    tests[506]["input"]    = 506
    tests[506]["expected"] = "Variant Also Negotiates"

    tests[510]["input"]    = 510
    tests[510]["expected"] = "Not Extended"

    tests[511]["input"]    = 511
    tests[511]["expected"] = "Network Authentication Required"

    for (i in tests) {
        err = _test_status_text(tests[i])
        if (err) {
            return "test_status_text: " err
        }
    }
}

function _test_status_text(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["input"])
    actual = response::status_text(tc["input"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

