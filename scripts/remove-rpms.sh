#!/usr/bin/env bash

echo "removing all RPMs from this directory"
for i in {{0..9},{A..Z},{a..z}}
do
    rm -f $i*.rpm
done

