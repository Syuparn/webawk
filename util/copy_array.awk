@namespace "util"

# NOTE: define only generally-used helper functions in util! (not specific ones)

# NOTE: arg "new" is destructively updated because array cannot be returned
function copy_array(orig, new) {
    delete new

    for (key in orig) {
        if (awk::typeof(orig[key]) == "array") {
            # HACK: subarray must be initialized before copying (to tell this var is array)
            new[key][1] = ""
            delete new[key][1]

            copy_array(orig[key], new[key])
        } else {
            new[key] = orig[key]
        }
    }
}
