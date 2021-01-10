@include "util/copy_array.awk"

BEGIN {
    err = test_copy_array_1_element()
    if (err) {
        print err
        exit 1
    }

    err = test_copy_array_multi_elements()
    if (err) {
        print err
        exit 1
    }

    err = test_copy_array_nested_elements()
    if (err) {
        print err
        exit 1
    }

    err = test_copy_array_subarray()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_copy_array_1_element(    input, log_prefix) {
    input[1] = "one"
    log_prefix = "test_copy_array_1_element"
    util::copy_array(input, actual)

    if (length(actual) != length(input)) {
        return sprintf("%s: length must be %d. got=%d",
                log_prefix, length(input), length(actual))
    }

    for (key in input) {
        if (!(key in actual)) {
            return sprintf("%s: key %s must be contained", log_prefix, key)
        }
    
        if (actual[key] != input[key]) {
            return sprintf("%s: actual[%s] must be %s. got=%s",
                log_prefix, key, input[key], actual[key])
        }
    }
}

function test_copy_array_multi_elements(    input, log_prefix) {
    input[1] = "one"
    input[2] = "two"
    input["THREE"] = "three"
    log_prefix = "test_copy_array_multi_elements"
    util::copy_array(input, actual)

    if (length(actual) != length(input)) {
        return sprintf("%s: length must be %d. got=%d", 
                log_prefix, length(input), length(actual))
    }

    for (key in input) {
        if (!(key in actual)) {
            return sprintf("%s: key %s must be contained", log_prefix, key)
        }

        if (actual[key] != input[key]) {
            return sprintf("%s: actual[%s] must be %s. got=%s",
                log_prefix, key, input[key], actual[key])
        }
    }
}

function test_copy_array_nested_elements(    input, log_prefix) {
    input[1][1] = "oneone"
    input[1][2] = "onetwo"
    log_prefix = "test_copy_array_nested_elements"
    util::copy_array(input, actual)

    if (!(1 in actual)) {
        return sprintf("%s: key %s must be contained", log_prefix, 1)
    }

    if (typeof(actual[1]) != "array") {
        return sprintf("%s: actual[1] must be array. got=%s", log_prefix, actual[1])
    }

    if (length(actual[1]) != length(input[1])) {
        return sprintf("%s: length of actual[1] must be %d. got=%d",
                log_prefix, length(input[1]), length(actual[1]))
    }

    for (key in input[1]) {
        if (!(key in actual[1])) {
            return sprintf("%s: key %s must be contained in actual[1]", log_prefix, key)
        }
    
        if (actual[1][key] != input[1][key]) {
            return sprintf("%s: actual[1][%s] must be %s. got=%s",
                log_prefix, key, input[1][key], actual[1][key])
        }
    }
}

function test_copy_array_subarray(    input, log_prefix) {
    input[1][1] = "one"
    input[1][2] = "two"
    input[1]["THREE"] = "three"
    log_prefix = "test_copy_array_subarray"
    util::copy_array(input[1], actual)

    if (length(actual) != length(input[1])) {
        return sprintf("%s: length must be %d. got=%d",
                log_prefix, length(input[1]), length(actual))
    }

    for (key in input[1]) {
        if (!(key in actual)) {
            return sprintf("%s: key %s must be contained", log_prefix, key)
        }
    
        if (actual[key] != input[1][key]) {
            return sprintf("%s: actual[%s] must be %s. got=%s",
                log_prefix, key, input[1][key], actual[key])
        }
    }
}
