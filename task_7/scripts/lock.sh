#!/bin/bash

SCRIPT="$1"
LOCKFILE=/tmp/log_parser.lock

if [ -f $LOCKFILE ]
then
  echo Script is running!
  exit 0 
else
  echo "$$" > $LOCKFILE
  trap 'rm -f $LOCKFILE"; exit $?' INT TERM EXIT
  $SCRIPT
  rm -f $LOCKFILE
  trap - INT TERM EXIT
fi