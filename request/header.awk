@namespace "request"

function parse_headers(req_reader, headers,    previous_fs) {
    previous_fs = FS
    FS = ": +"

    delete headers
    while ((req_reader |& getline) > 0) {
        if (!$0) {
            # if empty line is found, stop parsing (because this means end of headers)
            break
        }

        headers[$1] = $2
    }

    FS = previous_fs
}
