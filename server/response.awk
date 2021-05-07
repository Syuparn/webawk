@namespace "server"

@include "json/marshal.awk"
@include "response/response.awk"
@include "server/globalvars.awk"

function respond(statuscode, body, headers,    json_str) {
    headers["Connection"] = "keep-alive"

    json_str = json::marshal(body)
    if (json_str) {
        headers["Content-Length"] = length(json_str)
        headers["Content-Type"] = "application/json"
    }

    # update response flag
    awk::_RESPONDED = 1

    return response::response_lines(statuscode, headers, json_str)
}
