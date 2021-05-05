@include "json/marshal.awk"

BEGIN {
    err = test_marshal()
    if (err) {
        print err
        exit 1
    }

    print "passed"
}

function test_marshal(    tests,    splitted) {
    tests[1]["title"]    = "number"
    tests[1]["input"]    = 1
    tests[1]["expected"] = "1"

    tests[2]["title"]    = "string"
    tests[2]["input"]    = "foo"
    tests[2]["expected"] = "\"foo\""

    tests[3]["title"]         = "associative array with 1 element"
    tests[3]["input"]["name"] = "Taro"
    tests[3]["expected"]      = "{\"name\":\"Taro\"}"

    tests[4]["title"]    = "array with 1 element"
    tests[4]["input"][1] = "Taro"
    tests[4]["expected"] = "[\"Taro\"]"

    tests[5]["title"]            = "associative array with multiple elements"
    tests[5]["input"]["name"]    = "Taro"
    tests[5]["input"]["age"]     = 20
    tests[5]["input"]["address"] = "Tokyo"
    tests[5]["expected"]         = "{\"address\":\"Tokyo\",\"age\":20,\"name\":\"Taro\"}"

    tests[6]["title"]    = "array with multiple elements"
    tests[6]["input"][1] = "Taro"
    tests[6]["input"][2] = "Jiro"
    tests[6]["input"][3] = "Saburo"
    tests[6]["expected"] = "[\"Taro\",\"Jiro\",\"Saburo\"]"

    tests[7]["title"]       = "array of arrays"
    tests[7]["input"][1][1] = "oneone"
    tests[7]["input"][1][2] = "onetwo"
    tests[7]["input"][2][1] = "twoone"
    tests[7]["input"][2][2] = "twotwo"
    tests[7]["expected"]    = "[[\"oneone\",\"onetwo\"],[\"twoone\",\"twotwo\"]]"

    tests[8]["title"]           = "array of associative arrays"
    tests[8]["input"][1]["one"] = "oneone"
    tests[8]["input"][1]["two"] = "onetwo"
    tests[8]["input"][2]["one"] = "twoone"
    tests[8]["input"][2]["two"] = "twotwo"
    tests[8]["expected"]        = "[{\"one\":\"oneone\",\"two\":\"onetwo\"},{\"one\":\"twoone\",\"two\":\"twotwo\"}]"

    tests[9]["title"]         = "associative array of arrays"
    tests[9]["input"]["a"][1] = "a1"
    tests[9]["input"]["a"][2] = "a2"
    tests[9]["input"]["b"][1] = "b1"
    tests[9]["input"]["b"][2] = "b2"
    tests[9]["expected"] = "{\"a\":[\"a1\",\"a2\"],\"b\":[\"b1\",\"b2\"]}"

    tests[10]["title"]           = "associative array of associative arrays"
    tests[10]["input"]["a"]["A"] = "aA"
    tests[10]["input"]["a"]["B"] = "aB"
    tests[10]["input"]["b"]["A"] = "bA"
    tests[10]["input"]["b"]["B"] = "bB"
    tests[10]["expected"] = "{\"a\":{\"A\":\"aA\",\"B\":\"aB\"},\"b\":{\"A\":\"bA\",\"B\":\"bB\"}}"

    tests[11]["title"]    = "array of numbers"
    tests[11]["input"][1] = 10
    tests[11]["input"][2] = 20
    tests[11]["expected"] = "[10,20]"

    tests[12]["title"]    = "array of multiple types"
    tests[12]["input"][1] = "ten"
    tests[12]["input"][2] = 20
    tests[12]["input"][3] = "30"
    tests[12]["expected"] = "[\"ten\",20,\"30\"]"

    # NOTE: in awk, non-intialized number-like string is treated as strnum type
    #       (neither number nor string!)
    tests[13]["title"]    = "strnum type"
    # create strnum by splitting string
    split("5", splitted)
    tests[13]["input"] = splitted[1] # strnum "5"
    tests[13]["expected"] = "\"5\""

    for (i in tests) {
        err = _test_marshal(tests[i])
        if (err) {
            return "test_marshal: " err
        }
    }
}

function _test_marshal(tc,    log_prefix, actual) {
    log_prefix = sprintf("case '%s'", tc["title"])
    actual = json::marshal(tc["input"])

    if (actual != tc["expected"]) {
        return sprintf("%s: result must be '%s'. got='%s'",
            log_prefix, tc["expected"], actual)
    }

    return ""
}

