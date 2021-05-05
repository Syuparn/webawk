@namespace "json"

function marshal(v) {
    if (awk::typeof(v) == "number") {
        return v
    }
    if (awk::typeof(v) == "string" || awk::typeof(v) == "strnum") {
        return sprintf("\"%s\"", v)
    }
    if (awk::typeof(v) == "array") {
        if (is_numeric_array(v)) {
            return _marshal_numeric_array(v)
        } else {
            return _marshal_associative_array(v)
        }
    }
}

function _marshal_associative_array(v,    i, len, sorted, pair, json) {
    json = "{"
    len = awk::asorti(v, sorted)
    for (i = 1; i <= len; i++) {
        pair = marshal(sorted[i]) ":" marshal(v[sorted[i]])
        json = json pair
        # NOTE: avoid trailing comma
        if (i < len) {
            json = json ","
        }
    }
    json = json "}"
    return json
}

function _marshal_numeric_array(v,    i, len, json) {
    json = "["
    len = length(v)
    for (i = 1; i <= len; i++) {
        json = json marshal(v[i])
        # NOTE: avoid trailing comma
        if (i < len) {
            json = json ","
        }
    }
    json = json "]"
    return json
}

function is_numeric_array(arr,    i, len) {
    if (awk::typeof(arr) != "array") {
        return 0
    }

    len = length(arr)
    for (i = 1; i <= len; i++) {
        # if arr[i] is not found, arr has non-numeric key instead
        if (!(i in arr)) {
            return 0
        }
    }

    return 1
}
