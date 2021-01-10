@namespace "json"

# NOTE: this function requires jq be installed!
function jq(json, query,    cmd, elem) {
    if (query == "") {
        # if query is not passed, return whole of json string
        idx = ".";
    }

    # NOTE: -M to eliminate color info and -c to make result 1 line
    cmd = sprintf("echo '%s' | jq -cM '%s'", json, query) ;
    cmd | getline elem;
    close(cmd);

    return elem;
}
