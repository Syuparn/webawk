@include "server/request.awk"
@include "server/reset.awk"
@include "server/response.awk"

# return wether request method is POST with end-point path_template
function POST(path_template) {
    return server::got_request("POST", path_template)
}

# return wether request method is GET with end-point path_template
function GET(path_template) {
    return server::got_request("GET", path_template)
}

# return wether request method is PUT with end-point path_template
function PUT(path_template) {
    return server::got_request("PUT", path_template)
}

# return wether request method is DELETE with end-point path_template
function DELETE(path_template) {
    return server::got_request("DELETE", path_template)
}

# return wether request method is PATCH with end-point path_template
function PATCH(path_template) {
    return server::got_request("PATCH", path_template)
}

# return command to receive request and send back response
function http_service(    port) {
    # default port
    port = "8080"
    if (PORT) {
        port = PORT
    }
    return "/inet/tcp/" port "/0/0"
}

# get and load request
function load_req() {
    server::reset_globals()
    server::load_request(http_service())
}

# find pathparam from received URL
function path(key) {
    return server::find_pathparam(key)
}

# only 1st arg: check if the URL contains query key
# with 2nd arg: assign all queries from the URL to "queries"
function query(key, queries) {
    if (!queries) {
        return server::got_query(key)
    }
    # TODO: 2nd arg
}

# send back response
function res(statuscode, v,   res_str) {
    res_str = server::respond(statuscode, v)
    print res_str |& http_service()
    close(http_service())
}

function default_res(    body) {
    body["error"] = "Oops! Any of patterns did not match to the request."
    res(404, body)
}
