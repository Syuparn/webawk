@namespace "request"

function parse_request_line(req_reader, attrs) {
    req_reader |& getline

    attrs["method"]  = $1
    attrs["url"]    = $2
    attrs["version"] = $3
}
