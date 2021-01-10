# NOTE: jq must be installed!
@include "json/jq.awk"

BEGIN {
    err = test_jq()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_jq(    tests) {
    tests[1]["title"]    = "fetch itself"
    tests[1]["json"]     = "{\"name\": \"taro\"}"
    tests[1]["query"]    = "."
    # result is minified
    tests[1]["expected"] = "{\"name\":\"taro\"}"

    tests[2]["title"]    = "fetch value"
    tests[2]["json"]     = "{\"name\": \"taro\", \"age\": 20}"
    tests[2]["query"]    = ".age"
    tests[2]["expected"] = 20

    tests[3]["title"]    = "query with pipeline"
    tests[3]["json"]     = "{\"ids\": [1, 2, 3, 4, 5]}"
    tests[3]["query"]    = ".ids | length"
    tests[3]["expected"] = 5

    for (i in tests) {
        err = _test_jq(tests[i])
        if (err) {
            return "test_jq: " err
        }
    }
}

function _test_jq(tc, f,    log_prefix, actual, len) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = json::jq(tc["json"], tc["query"])

    if (actual != tc["expected"]) {
        return sprintf("%s: body must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}
