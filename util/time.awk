@namespace "util"

# NOTE: define only generally-used helper functions in util! (not specific ones)

function format_time(timestamp) {
    # this follows RFC7231 date format
    # NOTE: "LC_ALL=c" must be set, otherwise strftime might encode time in other languages

    uses_utc = 1 # true
    return awk::strftime("%a, %d %b %Y %H:%M:%S %Z", timestamp, uses_utc)
}
