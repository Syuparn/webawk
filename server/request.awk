@namespace "server"

@include "json/jq.awk"
@include "request/pathparam.awk"
@include "request/request.awk"
@include "server/globalvars.awk"
@include "util/copy_array.awk"

function load_request(req_reader,    request) {
    request::parse_request(req_reader, request)

    # assign each element to global variables
    awk::HTTP_VERSION = request["version"]
    awk::HTTP_METHOD = request["method"]
    awk::REQUEST_PATH = request["path"]
    util::copy_array(request["headers"], awk::REQUEST_HEADERS)
    util::copy_array(request["queries"], awk::REQUEST_QUERIES)
    awk::REQUEST_BODY = request["body"]
}

function got_request(method, path_template,    ok) {
    # NOTE: if any response for the current request is sent,
    #       no more requests are matched
    if (awk::_RESPONDED) {
        return 0
    }

    # NOTE: pathparam is updated when new path_template is passed
    #       (not when new request is received!)
    _reset_pathparam()

    if (method != awk::HTTP_METHOD) {
        return 0
    }

    # if no pathparams are passed, compare paths directly
    if (!request::contains_pathparam(path_template)) {
        return path_template == awk::REQUEST_PATH
    }

    ok = request::parse_pathparam(path_template, awk::REQUEST_PATH, awk::REQUEST_PATHPARAMS)
    return ok
}

function _reset_pathparam() {
    for (k in awk::REQUEST_PATHPARAMS) {
        delete awk::REQUEST_PATHPARAMS[k]
    }
}

function got_query(key, value,    ok) {
    # if 2nd arg is ignored, check only key existence
    if (!value) {
        return key in awk::REQUEST_QUERIES
    }

    if (!(key in awk::REQUEST_QUERIES)) {
        return 0
    }

    for (i in awk::REQUEST_QUERIES[key]) {
        if (awk::REQUEST_QUERIES[key][i] == value) {
            return 1
        }
    }

    return 0
}

function find_pathparam(key) {
    # NOTE: if key is referred directly, empty value is assigned implicitly
    if (key in awk::REQUEST_PATHPARAMS) {
        return awk::REQUEST_PATHPARAMS[key]
    }
    return ""
}

function find_query(key, queries) {
    # init queries
    delete queries

    if (!(key in awk::REQUEST_QUERIES)) {
        return
    }
    for (i in awk::REQUEST_QUERIES[key]) {
        queries[i] = awk::REQUEST_QUERIES[key][i]
    }
}

function find_body(query,    result) {
    result = json::jq(awk::REQUEST_BODY, query)
    if (result == "null") {
        return ""
    }
    return _unquote_doublequotes(result)
}

function _unquote_doublequotes(s) {
    if (match(s, "^\".*\"$")) {
        return substr(s, 2, length(s) - 2)
    }
    return s
}
