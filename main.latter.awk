# NOTE: This file is the latter part of awk exec source.
#       User input is inserted in the middle part.

# reset global variable and listen next request
# NOTE: this pattern must be matched in each record
1 {
    load_req()
}
# close connection
END {
    close(http_service())
}
