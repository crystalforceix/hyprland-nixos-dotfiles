#!/bin/sh

DIRECTORY="/run/media/$USER"

if [ -d "$DIRECTORY" ]
then
  [ "$(/usr/bin/ls -A "$DIRECTORY")" ] && echo "禍 " || echo ""
else
  echo ""
fi
