@include "server/main_test.awk"
@include "server/request.awk"

BEGIN {
    err = test_load_request()
    if (err) {
        print err
        exit 1
    }
    err = test_got_request()
    if (err) {
        print err
        exit 1
    }
    err = test_got_request_pathparam()
    if (err) {
        print err
        exit 1
    }
    err = test_got_request_already_responded()
    if (err) {
        print err
        exit 1
    }
    err = test_got_query()
    if (err) {
        print err
        exit 1
    }
    err = test_got_query_only_1st_arg()
    if (err) {
        print err
        exit 1
    }
    err = test_got_query_number_key_value()
    if (err) {
        print err
        exit 1
    }
    err = test_find_pathparam_found()
    if (err) {
        print err
        exit 1
    }
    err = test_find_pathparam_not_found()
    if (err) {
        print err
        exit 1
    }
    err = test_find_query()
    if (err) {
        print err
        exit 1
    }
    err = test_find_header_found()
    if (err) {
        print err
        exit 1
    }
    err = test_find_header_not_found()
    if (err) {
        print err
        exit 1
    }
    err = test_find_body()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_load_request(    tests, f, err) {
    tests[1]["title"]                                 = "request with body"
    tests[1]["fixturename"]                           = "request_with_body.txt"
    tests[1]["expected"]["version"]                   = "HTTP/1.1"
    tests[1]["expected"]["method"]                    = "POST"
    tests[1]["expected"]["path"]                      = "/languages"
    tests[1]["expected"]["headers"]["Content-Length"] = 15
    tests[1]["expected"]["headers"]["Content-Type"]   = "application/json"
    # no query parameters
    tests[1]["expected"]["queries"][""]               = ""
    delete tests[1]["expected"]["queries"][""]
    tests[1]["expected"]["body"]                      = "{\"name\": \"AWK\"}"

    tests[2]["title"]                                 = "request with query parameters"
    tests[2]["fixturename"]                           = "request_with_query.txt"
    tests[2]["expected"]["version"]                   = "HTTP/1.1"
    tests[2]["expected"]["method"]                    = "GET"
    tests[2]["expected"]["path"]                      = "/articles"
    # no request headers
    tests[2]["expected"]["headers"][""] = ""
    delete tests[2]["expected"]["headers"][""]
    # no query parameters
    tests[2]["expected"]["queries"]["page"][1]        = "1"
    tests[2]["expected"]["queries"]["tag"][1]         = "awk"
    tests[2]["expected"]["queries"]["tag"][2]         = "web"
    tests[2]["expected"]["body"]                      = ""

    for (i in tests) {
        f = test::setup_fixture(tests[i]["fixturename"])
        err = _test_load_request(tests[i], f)

        test::teardown_fixture(f)
        # NOTE: global variables must be reset after each test case
        test::reset_globals()

        if (err) {
            return "test_load_request: " err
        }
    }
}

function _test_load_request(tc, f,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    server::load_request(f)

    if (HTTP_VERSION != tc["expected"]["version"]) {
        return sprintf("%s: HTTP_VERSION must be '%s'. got='%s'",
            log_prefix, tc["expected"]["version"], HTTP_VERSION)
    }

    if (HTTP_METHOD != tc["expected"]["method"]) {
        return sprintf("%s: HTTP_METHOD must be '%s'. got='%s'",
            log_prefix, tc["expected"]["method"], HTTP_METHOD)
    }

    if (REQUEST_PATH != tc["expected"]["path"]) {
        return sprintf("%s: PATH must be '%s'. got='%s'",
            log_prefix, tc["expected"]["path"], REQUEST_PATH)
    }

    err = _test_headers(tc, f, REQUEST_HEADERS)
    if (err) {
        return sprintf("%s: %s", log_prefix, err)
    }

    err = _test_queries(tc, f, REQUEST_QUERIES)
    if (err) {
        return sprintf("%s: %s", log_prefix, err)
    }

    if (REQUEST_BODY != tc["expected"]["body"]) {
        return sprintf("%s: BODY must be '%s'. got='%s'",
            log_prefix, tc["expected"]["body"], REQUEST_BODY)
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

function test_got_request(    tests, err) {
    tests[1]["title"]    = "matched"
    tests[1]["method"]   = "GET"
    tests[1]["path"]     = "/names"
    tests[1]["expected"] = 1

    tests[2]["title"]    = "method is different"
    tests[2]["method"]   = "POST"
    tests[2]["path"]     = "/names"
    tests[2]["expected"] = 0

    tests[3]["title"]    = "path is different"
    tests[3]["method"]   = "GET"
    tests[3]["path"]     = "/articles"
    tests[3]["expected"] = 0

    for (i in tests) {
        # got request
        REQUEST_PATH = "/names"
        HTTP_METHOD  = "GET"

        err = _test_got_request(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_got_request: " err
        }
    }
}

function _test_got_request(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::got_request(tc["method"], tc["path"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_got_request_pathparam(    tests, err) {
    tests[1]["title"]                   = "no pathparam"
    tests[1]["method"]                  = "GET"
    tests[1]["path"]                    = "/names"
    tests[1]["path_template"]           = "/names"
    tests[1]["expected"]                = 1
    # init empty array
    tests[1]["expected_pathparams"][""] = ""
    delete tests[1]["expected_pathparams"][""]

    tests[2]["title"]                       = "matched"
    tests[2]["method"]                      = "GET"
    tests[2]["path"]                        = "/names/taro"
    tests[2]["path_template"]               = "/names/:name"
    tests[2]["expected"]                    = 1
    tests[2]["expected_pathparams"]["name"] = "taro"

    tests[3]["title"]                       = "path is different"
    tests[3]["method"]                      = "GET"
    tests[3]["path"]                        = "/names/taro"
    tests[3]["path_template"]               = "/books/:book"
    tests[3]["expected"]                    = 0
    # if not matched, pathparams are just removed
    tests[3]["expected_pathparams"][""]     = ""
    delete tests[3]["expected_pathparams"][""]

    for (i in tests) {
        # got request
        REQUEST_PATH = tests[i]["path"]
        HTTP_METHOD  = tests[i]["method"]

        err = _test_got_request_pathparam(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_got_request_pathparam: " err
        }
    }
}

function _test_got_request_pathparam(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::got_request(tc["method"], tc["path_template"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    for (name in tc["expected_pathparams"]) {
        if (!(name in REQUEST_PATHPARAMS)) {
            return sprintf("pathparam %s must be contained", name)
        }
        if (REQUEST_PATHPARAMS[name] != tc["expected_pathparams"][name]) {
            return sprintf("pathparam %s must be %s. got=%s",
                name, tc["expected_pathparams"][name], REQUEST_PATHPARAMS[name])
        }
    }

    return ""
}

function test_got_request_already_responded(    tests, err) {
    tests[1]["title"]     = "if responded, no more requests are matched"
    tests[1]["responded"] = 1
    tests[1]["expected"]  = 0

    tests[2]["title"]     = "not responded yet"
    tests[2]["responded"] = 0
    tests[2]["expected"]  = 1

    for (i in tests) {
        # got request
        REQUEST_PATH = "/names"
        HTTP_METHOD  = "GET"
        _RESPONDED = tests[i]["responded"]

        err = _test_got_request_already_responded(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_got_request_already_responded: " err
        }
    }
}

function _test_got_request_already_responded(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::got_request("GET", "/names")

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_got_query(    tests, err) {
    tests[1]["title"]    = "matched"
    tests[1]["key"]      = "tag"
    tests[1]["value"]    = "awk"
    tests[1]["expected"] = 1

    tests[2]["title"]    = "key not matched"
    tests[2]["key"]      = "name"
    tests[2]["value"]    = "taro"
    tests[2]["expected"] = 0

    tests[3]["title"]    = "value not matched"
    tests[3]["key"]      = "tag"
    tests[3]["value"]    = "http"
    tests[3]["expected"] = 0

    for (i in tests) {
        # got queries
        REQUEST_QUERIES["tag"][1] = "web"
        REQUEST_QUERIES["tag"][2] = "awk"

        err = _test_got_query(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_got_query: " err
        }
    }
}

function _test_got_query(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::got_query(tc["key"], tc["value"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_got_query_only_1st_arg(    tests, err) {
    tests[1]["title"]    = "key found"
    tests[1]["key"]      = "tag"
    tests[1]["expected"] = 1

    tests[2]["title"]    = "key not found"
    tests[2]["key"]      = "name"
    tests[2]["expected"] = 0

    for (i in tests) {
        # got queries
        REQUEST_QUERIES["tag"][1] = "web"
        REQUEST_QUERIES["tag"][2] = "awk"

        err = _test_got_query_only_1st_arg(tests[i], f)
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_got_query_only_1st_arg: " err
        }
    }
}

function _test_got_query_only_1st_arg(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::got_query(tc["key"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_got_query_number_key_value(    tests, err) {
    tests[1]["title"]    = "number key"
    tests[1]["key"]      = "4"
    tests[1]["value"]    = "four"
    tests[1]["expected"] = 1

    tests[2]["title"]    = "number value"
    tests[2]["key"]      = "five"
    tests[2]["value"]    = "5"
    tests[2]["expected"] = 1

    for (i in tests) {
        # got queries
        REQUEST_QUERIES["4"][1] = "four"
        REQUEST_QUERIES["five"][1] = "5"

        err = _test_got_query(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_got_query_number_key_value: " err
        }
    }
}

function test_find_pathparam_found(    tests, err) {
    tests[1]["title"]    = "found"
    tests[1]["key"]      = "name"
    tests[1]["expected"] = "taro"

    for (i in tests) {
        # got pathparams
        REQUEST_PATHPARAMS["name"] = "taro"

        err = _test_find_pathparam(tests[i], f)
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_find_pathparam_found: " err
        }
    }
}

function test_find_pathparam_not_found(    tests, err) {
    tests[1]["title"]    = "not found"
    tests[1]["key"]      = "name"
    tests[1]["expected"] = ""

    for (i in tests) {
        err = _test_find_pathparam(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_find_pathparam_not_found: " err
        }
    }
}

function _test_find_pathparam(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::find_pathparam(tc["key"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_find_query(    tests, err) {
    tests[1]["title"]       = "found"
    tests[1]["key"]         = "tag"
    tests[1]["expected"][1] = "web"
    tests[1]["expected"][2] = "awk"

    tests[2]["title"]       = "not found"
    tests[2]["key"]         = "limit"
    tests[2]["expected"][""] = ""
    delete tests[2]["expected"][""]

    for (i in tests) {
        REQUEST_QUERIES["tag"][1] = "web"
        REQUEST_QUERIES["tag"][2] = "awk"

        err = _test_find_query(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_find_query: " err
        }
    }
}

function _test_find_query(tc,     actual, i){
    log_prefix = sprintf("case '%s'", tc["title"])
    server::find_query(tc["key"], actual)

    if (length(actual) != length(tc["expected"])) {
        return sprintf("%s: queries length must be %d. got=%d",
            log_prefix, length(tc["expected"]), length(actual))
    }

    for (i = 1; i <= length(tc["expected"]); i++) {
        if (actual[i] != tc["expected"][i]) {
            return sprintf("%s: queries[%d] must be '%s'. got='%s'",
                log_prefix, i, tc["expected"][i], actual[i])
        }
    }

    return ""
}

function test_find_header_found(    tests, err) {
    tests[1]["title"]    = "found"
    tests[1]["key"]      = "Content-Type"
    tests[1]["expected"] = "application/json"

    for (i in tests) {
        # got pathparams
        REQUEST_HEADERS["Content-Type"] = "application/json"

        err = _test_find_header(tests[i], f)
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_find_header_found: " err
        }
    }
}

function test_find_header_not_found(    tests, err) {
    tests[1]["title"]    = "not found"
    tests[1]["key"]      = "name"
    tests[1]["expected"] = ""

    for (i in tests) {
        err = _test_find_header(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_find_header_not_found: " err
        }
    }
}

function _test_find_header(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::find_header(tc["key"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_find_body(    tests, err) {
    tests[1]["title"]    = "found"
    tests[1]["body"]     = "{\"name\":\"Taro\"}"
    tests[1]["query"]    = ".name"
    tests[1]["expected"] = "Taro"

    tests[2]["title"]    = "not found"
    tests[2]["body"]     = "{\"name\":\"Taro\"}"
    tests[2]["query"]    = ".age"
    tests[2]["expected"] = ""

    tests[3]["title"]    = "numeric element"
    tests[3]["body"]     = "{\"age\":20}"
    tests[3]["query"]    = ".age"
    tests[3]["expected"] = "20"

    printf "parse error below is intentional! don't worry :)\n"
    tests[4]["title"]    = "syntax error"
    tests[4]["body"]     = "{\"age\":20"
    tests[4]["query"]    = ".age"
    tests[4]["expected"] = ""

    for (i in tests) {
        REQUEST_BODY = tests[i]["body"]

        err = _test_find_body(tests[i])
        # NOTE: global variables must be reset
        test::reset_globals()
        if (err) {
            return "test_find_body: " err
        }
    }
}

function _test_find_body(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::find_body(tc["query"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
