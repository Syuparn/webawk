#! /bin/bash

# NOTE: this must be set, otherwise Date header might not be encoded in English
export LC_ALL=c

print_help() {
    echo "-f progfile : run program file instead of program string"
    echo "-h          : get help"
    echo "-n          : how many requests it can handle (default: 2147483647)"
    echo "-p port     : port to listen (default: 8080)"
    echo "-c command  : which awk command to run (default: gawk)"
    echo ""
    print_example
}

print_example() {
    echo "Example:"
    echo "  $(basename $0) 'GET(\"/names\") {b[\"names\"][1]=\"Taro\"; res(200, b)}'"
}

absolute_path() {
    readlink -f $1
}

# default port
PORT=8080
# default numbers of requests it can handle before finishing
REQUEST_LIMIT=2147483647
# default awk command
AWK_COMMAND=gawk

# NOTE: ':' after each character means the option requires argument
while getopts :f:hn:p:c: OPT
do
    case $OPT in
        f)  FILENAME=$(absolute_path $OPTARG)
            ;;
        n)  REQUEST_LIMIT=$OPTARG
            ;;
        p)  PORT=$OPTARG
            ;;
        c)  AWK_COMMAND=$OPTARG
            ;;
        h)  print_help
            exit 0
            ;;
        \?) print_example
            ;;
    esac
done

# nessesary to receive positional args after options
shift $((OPTIND - 1))

# NOTE: move current directory to which this source is located in
# to include modules
cd $(dirname $0)

# run program file
if [ -n "$FILENAME" ]; then
    seq $REQUEST_LIMIT |\
        $AWK_COMMAND -v PORT="$PORT" "$(cat main.former.awk; cat $FILENAME; cat main.latter.awk)"
    exit 0
fi

if [ $# -ne 1 ]; then
    echo "program should be passed as 1st argument."
    print_example
    exit 1
fi

# run program string in command
# NOTE: merge programs dynamically
seq $REQUEST_LIMIT |\
    $AWK_COMMAND -v PORT="$PORT" "$(cat main.former.awk; echo $1; cat main.latter.awk)"
