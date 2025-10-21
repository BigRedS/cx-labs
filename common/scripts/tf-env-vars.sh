#! /bin/bash

echo "{"
env | grep -e '^CX' -e '^USER=' | awk -F= '{print "  \"" tolower($1) "\": \"" $2 "\""}'
echo "}"
