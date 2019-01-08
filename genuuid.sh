#!/bin/bash

count=1

while getopts ":l:c:k:" opt; do
  case $opt in
    c)
      count=${OPTARG}
      ;;
    *)
      echo "Usage: $0 [OPTION]..."
      echo "Print a random generated uuid4. With no OPTION, $count uuids will be generated"
      echo ""
      echo "-c {int}             count of the uuid's"
      exit 1
      ;;
  esac
done

python -c 'from uuid import uuid4; print("\n".join([str(uuid4()) for _ in range(0, '$count')]))'
exit 0
