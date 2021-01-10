@namespace "response"

function header_lines(headers,    out, sorted, len, i) {
    out = ""
    # sort by key in alphabetical order
    len = awk::asorti(headers, sorted)
    for (i = 1; i <= len; i++) {
        out = out sprintf("%s: %s", sorted[i], headers[sorted[i]]) "\r\n"
    }
    return out
}
