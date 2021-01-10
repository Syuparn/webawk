@include "request/main_test.awk"
@include "request/pathparam.awk"

BEGIN {
    err = test_parse_pathparam()
    if (err) {
        print err
        exit 1
    }
    err = test_contains_pathparam()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_parse_pathparam(    tests) {
    tests[1]["title"]            = "url template with 1 pathparam"
    tests[1]["template_url"]     = "/names/:name"
    tests[1]["received_url"]     = "/names/taro"
    tests[1]["expected"]["name"] = "taro"
    tests[1]["expected_ok"]      = 1

    tests[2]["title"]               = "url template with 2 pathparams"
    tests[2]["template_url"]        = "/articles/:article/comments/:comment"
    tests[2]["received_url"]        = "/articles/12/comments/345"
    tests[2]["expected"]["article"] = 12
    tests[2]["expected"]["comment"] = 345
    tests[2]["expected_ok"]         = 1

    tests[3]["title"]               = "url template without pathparams"
    tests[3]["template_url"]        = "/articles"
    tests[3]["received_url"]        = "/articles"
    # inintialize empty subarray
    tests[3]["expected"][""]        = ""
    delete tests[3]["expected"][""]
    tests[3]["expected_ok"]         = 1

    tests[4]["title"]               = "url not matched"
    tests[4]["template_url"]        = "/articles/mydiary/pages/:page"
    tests[4]["received_url"]        = "/articles/:articles/comments/10"
    # inintialize empty subarray
    tests[4]["expected"][""]        = ""
    delete tests[4]["expected"][""]
    tests[4]["expected_ok"]         = 0

    for (i in tests) {
        err = _test_parse_pathparam(tests[i])
        if (err) {
            return "test_parse_pathparam: " err
        }
    }
}

function _test_parse_pathparam(tc,    log_prefix, actual, ok) {
    log_prefix = sprintf("case '%s'", tc["title"])
    ok = request::parse_pathparam(tc["template_url"], tc["received_url"], actual)

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

    if (ok != tc["expected_ok"]) {
        return sprintf("%s: ok must be %s. got=%s",
            log_prefix, tc["expected_ok"], ok)
    }

    return ""
}

function test_contains_pathparam(    tests) {
    tests[1]["title"]        = "url template with 1 pathparam"
    tests[1]["template_url"] = "/names/:name"
    tests[1]["expected"]     = "1"

    tests[2]["title"]        = "url template with 2 pathparams"
    tests[2]["template_url"] = "/articles/:article/comments/:comment"
    tests[2]["expected"]     = 1

    tests[3]["title"]        = "url template without pathparams"
    tests[3]["template_url"] = "/articles"
    tests[3]["expected"]     = 0

    for (i in tests) {
        err = _test_contains_pathparam(tests[i])
        if (err) {
            return "test_parse_pathparam: " err
        }
    }
}

function _test_contains_pathparam(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = request::contains_pathparam(tc["template_url"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be %s. got=%s",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
