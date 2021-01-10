#! /bin/bash

if [ $# -ne 1 ]; then
    echo "program should be passed as 1st argument." 1>&2
    echo "Example:" 1>&2
    echo "  $(basename $0) 'GET(\"/names\") {b[\"names\"][1]=\"Taro\"; res(200, b)}'" 1>&2
    exit 1
fi

# merge programs dynamically
gawk "$(cat main.former.awk; echo $1; cat main.latter.awk)"
