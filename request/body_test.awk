@include "request/main_test.awk"
@include "request/body.awk"

BEGIN {
    err = test_parse_body()
    if (err) {
        print err
        exit 1
    }
    err = test_parse_body_length()
    if (err) {
        print err
        exit 1
    }
    err = test_parse_body_rs_is_not_changed()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_parse_body(    tests, f) {
    tests[1]["title"]        = "json request body"
    tests[1]["body"]         = "{\"name\": \"awk\"}"
    tests[1]["content_type"] = "application/json"
    tests[1]["expected"]     = "{\"name\": \"awk\"}"

    tests[2]["title"]        = "xml request body"
    tests[2]["body"]         = "<name>awk</name>"
    tests[2]["content_type"] = "application/xml"
    tests[2]["expected"]     = "<name>awk</name>"

    # last byte is lost and replaced with space...
    tests[3]["title"]        = "plain request body"
    tests[3]["body"]         = "this is awk."
    tests[3]["content_type"] = "text/plain"
    tests[3]["expected"]     = "this is awk "

    for (i in tests) {
        f = test::string_to_stdin(tests[i]["body"])

        err = _test_parse_body(tests[i], f)
        test::teardown_fixture(f)
        if (err) {
            return "test_parse_body: " err
        }
    }
}

function _test_parse_body(tc, f,    log_prefix, actual, len) {
    log_prefix = sprintf("case '%s'", tc["title"])
    len = length(tc["body"])
    actual = request::parse_body(f, len, tc["content_type"])

    if (actual != tc["expected"]) {
        return sprintf("%s: body must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_parse_body_length(    tests, f) {
    tests[1]["title"]        = "bytes after content length are ignored"
    tests[1]["length"]       = 10
    tests[1]["body"]         = "1234567890abcde"
    tests[1]["content_type"] = "text/plain"
    # NOTE: last byte is replaced with space!
    tests[1]["expected"]     = "123456789 "

    for (i in tests) {
        f = test::string_to_stdin(tests[i]["body"])

        err = _test_parse_body_length(tests[i], f)
        test::teardown_fixture(f)
        if (err) {
            return "test_parse_body_length: " err
        }
    }
}

function _test_parse_body_length(tc, f,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = request::parse_body(f, tc["length"], tc["content_type"])

    if (actual != tc["expected"]) {
        return sprintf("%s: body must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_parse_body_rs_is_not_changed(    body, log_prefix, f, rs_original) {
    log_prefix = "test_parse_body_rs_is_not_changed"
    body = "mock body"
    f = test::string_to_stdin(body)

    # NOTE: setup RS explicitly, otherwise test depends on other test-case orders
    # (this wrongly passes even if parse_headers() in other testcase has already changed RS)
    rs_original = RS
    RS = "somers"

    err = _test_parse_body_rs_is_not_changed(log_prefix, f, length(body))
    test::teardown_fixture(f)
    # RS must be reset at the end of test!
    RS = rs_original

    if (err) {
        return err
    }

    return ""
}

function _test_parse_body_rs_is_not_changed(log_prefix, f, len,    rs_before, rs_after, _) {
    rs_before = RS
    _ = request::parse_body(f, len)
    rs_after = RS
    if (rs_after != rs_before) {
        return sprintf("%s: RS must not be changed. before='%s', after='%s'",
            log_prefix, rs_before, rs_after)
    }

    return ""
}
