# NOTE: This file is the latter part of awk exec source.
#       User input is inserted in the middle part.

# if request matched none of patterns, respond Not Found
!_RESPONDED {
    default_res()
}
# reset global variable and listen next request
# NOTE: this pattern must be matched in each record
1 {
    load_req()
}
# close connection
END {
    close(http_service())
}
