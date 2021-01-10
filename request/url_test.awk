@include "request/main_test.awk"
@include "request/url.awk"

BEGIN {
    err = test_parse_queries()
    if (err) {
        print err
        exit 1
    }
    err = test_parse_path()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_parse_queries(    tests, i) {
    tests[1]["title"]        = "url without queries"
    tests[1]["url"]          = "/names"
    # initialize empty subarray
    tests[1]["expected"][""] = ""
    delete tests[1]["expected"][""]

    tests[2]["title"]                = "url with 1 query"
    tests[2]["url"]                  = "/names?limit=100"
    tests[2]["expected"]["limit"][1] = 100

    tests[3]["title"]                = "url with multiple queries"
    tests[3]["url"]                  = "/names?page=2&sort=latest&limit=100"
    tests[3]["expected"]["page"][1]  = 2
    tests[3]["expected"]["sort"][1]  = "latest"
    tests[3]["expected"]["limit"][1] = 100

    tests[4]["title"]                = "url with multiple same-named queries"
    tests[4]["url"]                  = "/articles?tag=awk&tag=web"
    tests[4]["expected"]["tag"][1]   = "awk"
    tests[4]["expected"]["tag"][2]   = "web"

    for (i in tests) {
        err = _test_parse_queries(tests[i])
        if (err) {
            return "test_parse_queries: " err
        }
    }
}

function _test_parse_queries(tc,    log_prefix, actual, name, i) {
    log_prefix = sprintf("case '%s'", tc["title"])
    request::parse_queries(tc["url"], actual)

    if (length(actual) != length(tc["expected"])) {
        return sprintf("%s: length must be %d. got=%d",
            log_prefix, length(tc["expected"]), length(actual))
    }

    for (name in tc["expected"]) {
        if (!(name in actual)) {
            return sprintf("%s: query %s must be contained", log_prefix, name)
        }

        if (length(actual[name]) != length(tc["expected"][name])) {
        return sprintf("%s: length of actual[%s] must be %d. got=%d",
            log_prefix, name, length(tc["expected"][name]), length(actual[name]))
        }

        for (i in tc["expected"][name]) {
            if (actual[name][i] != tc["expected"][name][i]) {
                return sprintf("%s: actual[%s][%d] must be %s. got=%s",
                    log_prefix, name, i, tc["expected"][name][i], actual[name][i])
            }
        }
    }

    return ""
}

function test_parse_path(    tests, i) {
    tests[1]["title"]    = "url without queries"
    tests[1]["url"]      = "/names"
    tests[1]["expected"] = "/names"

    tests[2]["title"]    = "url with 1 query"
    tests[2]["url"]      = "/articles?limit=100"
    tests[2]["expected"] = "/articles"

    for (i in tests) {
        err = _test_parse_path(tests[i])
        if (err) {
            return "test_parse_path: " err
        }
    }
}

function _test_parse_path(tc,    log_prefix, actual, name, i) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = request::parse_path(tc["url"])

    if (actual != tc["expected"]) {
        return sprintf("%s: path must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
