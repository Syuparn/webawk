@namespace "request"

@load "ordchr"

function parse_queries(url, queries,    query_string, query_pairs, elems, key, value) {
    if (!_has_queries(url)) {
        return
    }

    query_string = substr(url, index(url, "?") + 1)
    split(query_string, query_pairs, "&")

    for (i in query_pairs) {
        # NOTE: whole query_string cannot be decoded because
        #       %26("&") cannot be used as query separator
        split(query_pairs[i], elems, "=")
        key = _decode_url(elems[1])
        value = _decode_url(elems[2])

        queries[key][length(queries[key]) + 1] = value
    }
}

function parse_path(url) {
    if (!_has_queries(url)) {
        return url
    }

    return substr(url, 1, index(url, "?") - 1)
}

function _has_queries(url) {
    return index(url, "?") > 0
}

function _decode_url(url,    decoded_url) {
    decoded_url = url
    # NOTE: space decode must preceed percent decode, otherwise %2B("+") is decoded as " "
    gsub("\\+", " ", decoded_url)
    decoded_url = _percent_decode(decoded_url)
    return decoded_url
}

function _percent_decode(str,    decoded, encoded_char, hex_str, char) {
    # NOTE: decode appeared % character one-by-one,
    #       otherwise replace occurs 255 times (0x00~0xff)
    decoded = str
    while (match(decoded, /%[0-9a-fA-F]{2}/)) {
        encoded_char = substr(decoded, RSTART, RLENGTH)
        # extract hex (ex: "%2F" -> "2F")
        hex_str = encoded_char
        gsub("%", "", hex_str)
        # convert to char of the ascii code ("0x" "2F" -> 0x2F -> "/")
        char = awk::chr(awk::strtonum("0x" hex_str))
        # replace encoded_char with char
        gsub(encoded_char, char, decoded)
    }

    return decoded
}
