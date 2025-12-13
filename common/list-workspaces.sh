#! /bin/bash

if [ ! -d ./common ]; then
  echo "ERROR: Run this script in the root of the cx-labs repo!"
  exit
fi

wd=$(pwd)

echo "Listing terraform workspaces per type of lab"

echo "Any non-default workspace will have running resources attached"

echo "Default workspaces will exist even when there's nothing running, you'll have to check those manually :("

echo

find . -name Makefile | while read f; do
  cd $(dirname "$f")
  make workspaces
  cd "$wd"
done
