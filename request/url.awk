@namespace "request"

function parse_queries(url, queries,    query_string, query_pairs, elems, key, value) {
    if (!_has_queries(url)) {
        return
    }

    query_string = substr(url, index(url, "?") + 1)
    split(query_string, query_pairs, "&")

    for (i in query_pairs) {
        split(query_pairs[i], elems, "=")
        key = elems[1]
        value = elems[2]

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
