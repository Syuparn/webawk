@namespace "test"

@include "server/request.awk"


# return file reader command for getline
function setup_fixture(filename,    filepath) {
    filepath =  "server/testdata/" filename
    return sprintf("cat %s", filepath)
}

function teardown_fixture(f) {
    close(f)
}

function string_to_stdin(str) {
    return sprintf("echo '%s'", str)
}

function reset_globals() {
    awk::HTTP_VERSION = ""
    awk::HTTP_METHOD = ""
    awk::REQUEST_PATH = ""

    for (k in awk::REQUEST_HEADERS) {
        delete awk::REQUEST_HEADERS[k]
    }

    for (k in awk::REQUEST_QUERIES) {
        delete awk::REQUEST_QUERIES[k]
    }

    for (k in awk::REQUEST_PATHPARAMS) {
        delete awk::REQUEST_PATHPARAMS[k]
    }

    awk::REQUEST_BODY = ""

    awk::_RESPONDED = 0
}
