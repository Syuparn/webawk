# NOTE: declare these variables in default namespace
#       to reduce typing in top-level codes

BEGIN {
    # Global variables set in each request
    HTTP_VERSION = ""
    HTTP_METHOD = ""
    REQUEST_PATH = ""

    # initialize as an empty array
    REQUEST_HEADERS[""] = ""
    delete REQUEST_HEADERS[""]
    REQUEST_QUERIES[""] = ""
    delete REQUEST_QUERIES[""]
    REQUEST_PATHPARAMS[""] = ""
    delete REQUEST_PATHPARAMS[""]

    REQUEST_BODY = ""

    # 1 if response for the current request has already been sent
    _RESPONDED = 0
}