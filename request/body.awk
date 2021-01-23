@namespace "request"

function parse_body(req_reader, len, content_type,     previous_rs) {
    # NOTE: last byte of body is ignored!
    # (otherwise, getline waits the last byte char until connection closes)

    # HACK: read first len-1 chars as record separator
    previous_rs = RS
    RS = sprintf(".{%d}", len - 1)
    req_reader |& getline

    RS = previous_rs

    # NOTE: if removed last byte is a trailing space and close character is remained, do nothing
    # otherwise close characters are duplicated (ex: '{"a": "b"} ' -> '{"a": "b"}}')
    if (substr(RT, len - 1, 1) == _last_byte_of(content_type)) {
        return RT " "
    }

    return RT _last_byte_of(content_type)
}

function _last_byte_of(content_type) {
    if (content_type == "application/json") {
        return "}"
    } else if (content_type == "application/xml") {
        return ">"
    } else {
        # the lost last byte cannot be estimated...
        return " "
    }
}
