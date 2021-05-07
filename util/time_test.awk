@include "util/time.awk"

BEGIN {
    err = test_format_time()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_format_time(    tests, log_prefix) {
    uses_utc = 1 # true

    tests[1]["title"]    = "time 2021 May 7 12:34:56"
    #                              yyyy mm dd hh mm ss
    tests[1]["input"]    = mktime("2021 05 07 12 34 56", uses_utc)
    tests[1]["expected"] = "Fri, 07 May 2021 12:34:56 GMT"

    for (i in tests) {
        err = _test_format_time(tests[i])
        if (err) {
            return "test_format_time: " err
        }
    }
}

function _test_format_time(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = util::format_time(tc["input"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
