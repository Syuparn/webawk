#! /bin/bash

# NOTE: this must be set, otherwise Date header might not be encoded in English
export LC_ALL=c

for testfile in $(find ./ -name "*_test.awk" -type f); do
    echo $testfile
    gawk -f $testfile
done
