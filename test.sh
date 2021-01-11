#! /bin/bash

for testfile in $(find ./ -name "*_test.awk" -type f); do
    echo $testfile
    gawk -f $testfile
done
