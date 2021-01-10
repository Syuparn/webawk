@namespace "request"

@include "request/body.awk"
@include "request/header.awk"
@include "request/request_line.awk"
@include "request/url.awk"

function parse_request(req_reader, request,    previous_rs, attrs, queries) {
    previous_rs = RS
    # http record separator
    RS = "\r\n"

    parse_request_line(req_reader, attrs)
    request["version"] = attrs["version"]
    request["method"] = attrs["method"]

    request["path"] = parse_path(attrs["url"])

    # NOTE: initialize variable to be recognized as an array
    request["queries"][""] = ""
    delete request["queries"][""]
    parse_queries(attrs["url"], request["queries"])

    # NOTE: initialize variable to be recognized as an array
    request["headers"][""] = ""
    delete request["headers"][""]
    parse_headers(req_reader, request["headers"])

    # read body if exists
    if ("Content-Length" in request["headers"] && "Content-Type" in request["headers"]) {
        request["body"] = parse_body(req_reader,
            request["headers"]["Content-Length"], request["headers"]["Content-Type"])
    }

    # reset record separator
    RS = previous_rs
}
