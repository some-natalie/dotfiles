#!/bin/bash

echo "long running job will take 30 minutes to complete"
for i in {1..30}
do
    echo "wait a minute for the $i time"
    sleep 60
done

