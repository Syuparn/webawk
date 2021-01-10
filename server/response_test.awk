@include "server/main_test.awk"
@include "server/response.awk"

BEGIN {
    err = test_respond()
    if (err) {
        print err
        exit 1
    }
    err = test_respond_with_body()
    if (err) {
        print err
        exit 1
    }
    err = test_respond_updates_responded()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_respond(    tests) {
    tests[1]["title"]       = "no content"
    tests[1]["statuscode"]  = 204
    tests[1]["expected"]    =\
        "HTTP/1.1 204 No Content\r\n"\
        "Connection: keep-alive\r\n"

    for (i in tests) {
        err = _test_respond(tests[i])
        # NOTE: global variables must be reset after each test case
        test::reset_globals()

        if (err) {
            return "test_respond: " err
        }
    }
}

function _test_respond(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::respond(tc["statuscode"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '\n%s'. got='\n%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_respond_with_body(    tests) {
    tests[1]["title"]         = "ok"
    tests[1]["statuscode"]    = 200
    tests[1]["body"]["name"]  = "Taro"
    tests[1]["expected"]    =\
        "HTTP/1.1 200 OK\r\n"\
        "Connection: keep-alive\r\n"\
        "Content-Length: 15\r\n"\
        "Content-Type: application/json\r\n"\
        "{\"name\":\"Taro\"}"

    for (i in tests) {
        err = _test_respond_with_body(tests[i], body)
        # NOTE: global variables must be reset after each test case
        test::reset_globals()

        if (err) {
            return "test_respond_with_body: " err
        }
    }
}

function _test_respond_with_body(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = server::respond(tc["statuscode"], tc["body"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '\n%s'. got='\n%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

function test_respond_updates_responded(    tests) {
    tests[1]["title"]       = "no content"
    tests[1]["statuscode"]  = 204
    tests[1]["expected"]    = 1

    for (i in tests) {
        err = _test_respond_updates_responded(tests[i])
        # NOTE: global variables must be reset after each test case
        test::reset_globals()

        if (err) {
            return "test_respond_updates_responded: " err
        }
    }
}

function _test_respond_updates_responded(tc,    log_prefix) {
    log_prefix = sprintf("case '%s'", tc["title"])
    server::respond(tc["statuscode"])

    if (_RESPONDED != tc["expected"]) {
        return sprintf("%s: result must be '%d'. got='%d'",
            log_prefix, tc["expected"], _RESPONDED)
    }

    return ""
}
