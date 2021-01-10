@include "request/header.awk"
@include "request/main_test.awk"

BEGIN {
    err = test_parse_headers()
    if (err) {
        print err
        exit 1
    }
    err = test_parse_headers_fs_is_not_changed()
    if (err) {
        print err
        exit 1
    }
    err = test_parse_headers_record_position_is_after_header()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_parse_headers(    tests, f) {
    tests[1]["title"]                    = "single line header"
    tests[1]["fixturename"]              = "header_single_line.txt"
    tests[1]["expected"]["Content-Type"] = "application/json"

    tests[2]["title"]                    = "multiple line headers"
    tests[2]["fixturename"]              = "header_multiple_lines.txt"
    tests[2]["expected"]["Host"]         = "localhost:8080"
    tests[2]["expected"]["Content-Type"] = "text/html; charset=UTF-8"

    tests[3]["title"]                      = "header followed by body"
    tests[3]["fixturename"]                = "header_with_body.txt"
    tests[3]["expected"]["Content-Length"] = "5"

    tests[4]["title"]                    = "empty headers"
    tests[4]["fixturename"]              = "header_empty.txt"
    # HACK: initialize tests["expected"] as an array
    tests[4]["expected"][""] = ""
    delete tests[4]["expected"][""]

    for (i in tests) {
        f = test::setup_fixture(tests[i]["fixturename"])

        err = _test_parse_headers(tests[i], f)
        test::teardown_fixture(f)
        if (err) {
            return "test_parse_headers: " err
        }
    }
}

function _test_parse_headers(tc, f,     log_prefix, headers) {
    log_prefix = sprintf("case '%s'", tc["title"])
    request::parse_headers(f, headers)

    if (length(headers) != length(tc["expected"])) {
        return sprintf("%s: length must be %d. got=%d",
            log_prefix, length(tc["expected"]), length(headers))
    }

    for (name in tc["expected"]) {
        if (!(name in headers)) {
            return sprintf("%s: header %s must be contained", log_prefix, name)
        }
        if (headers[name] != tc["expected"][name]) {
            return sprintf("%s: header %s must be %s. got=%s",
                log_prefix, name, tc["expected"][name], headers[name])
        }
    }

    return ""
}

function test_parse_headers_fs_is_not_changed(    log_prefix, f, fs_original) {
    log_prefix = "test_parse_headers_fs_is_not_changed"
    f = test::setup_fixture("header_single_line.txt")

    # NOTE: setup FS explicitly, otherwise test depends on other test-case orders
    # (this wrongly passes even if parse_headers() in other testcase has already changed FS)
    fs_original = FS
    FS = "somefs"

    err = _test_parse_headers_fs_is_not_changed(log_prefix, f)
    test::teardown_fixture(f)
    # FS must be reset at the end of test!
    FS = fs_original

    if (err) {
        return err
    }

    return ""
}

function _test_parse_headers_fs_is_not_changed(log_prefix, f,     fs_before, fs_after, _) {
    fs_before = FS
    err = request::parse_headers(f, _)
    if (err) {
        return sprintf("%s: (fatal) parse_headers unexpectedly failed. (%s)", log_prefix, err)
    }

    fs_after = FS
    if (fs_after != fs_before) {
        return sprintf("%s: FS must not be changed. before='%s', after='%s'",
            log_prefix, fs_before, fs_after)
    }

    return ""
}

function test_parse_headers_record_position_is_after_header(    log_prefix, f, fs_original) {
    log_prefix = "test_parse_headers_record_position_is_after_header"
    expected = "aiueo"

    f = test::setup_fixture("header_with_body.txt")

    err = _test_parse_headers_record_position_is_after_header(log_prefix, f, expected)
    test::teardown_fixture(f)
    if (err) {
        return err
    }

    return ""
}

function _test_parse_headers_record_position_is_after_header(log_prefix, f, expected,    actual, _) {
    err = request::parse_headers(f, _)
    if (err) {
        return sprintf("%s: (fatal) parse_headers unexpectedly failed. (%s)", log_prefix, err)
    }

    status = f |& getline actual
    if (status < 1) {
        return sprintf("%s: getline failed (status %d)", log_prefix, status)
    }

    if (actual != expected) {
        return sprintf("%s: next line must be '%s'. got='%s'",
            log_prefix, expected, actual)
    }

    return ""
}
