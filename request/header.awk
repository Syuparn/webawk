@namespace "request"

function parse_headers(req_reader, headers) {
    delete headers
    while ((req_reader |& getline) > 0) {
        if (!$0) {
            # if empty line is found, stop parsing (because this means end of headers)
            break
        }

        # separate by ":"
        # NOTE: FS cannot be used (otherwise, value like "localhost:8000" is torn!)
        match($0, ": *")
        headers[substr($0, 1, RSTART - 1)] = substr($0, RSTART + RLENGTH)
    }
}
