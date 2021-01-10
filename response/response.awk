@namespace "response"

@include "response/header.awk"
@include "response/response_line.awk"

function response_lines(status_code, headers, body,    lines) {
    lines = response_line(status_code)
    if (length(headers)) {
        # NOTE: header_lines ends with \r\n
        lines = lines "\r\n" header_lines(headers)
    }
    if (length(body)) {
        # add empty line before body
        lines = lines "\r\n" body
    }

    return lines
}
