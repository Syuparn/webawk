@namespace "response"

@include "response/statuscode.awk"

function response_line(status_code) {
    return sprintf("%s %d %s", "HTTP/1.1", status_code, status_text(status_code))
}
