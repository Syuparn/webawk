@namespace "test"

# return file reader command for getline
function setup_fixture(filename,    filepath) {
    filepath =  "request/testdata/" filename
    return sprintf("cat %s", filepath)
}

function teardown_fixture(f) {
    close(f)
}

function string_to_stdin(str) {
    return sprintf("echo '%s'", str)
}
