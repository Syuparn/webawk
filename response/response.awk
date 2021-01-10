@namespace "response"

@include "response/header.awk"
@include "response/response_line.awk"

function response_lines(status_code, headers, body,    lines) {
    lines = response_line(status_code)
    if (length(headers)) {
        lines = lines "\r\n" header_lines(headers)
    }
    if (length(body)) {
        # NOTE: header_lines ends with \r\n
        lines = lines body
    }

    return lines
}
