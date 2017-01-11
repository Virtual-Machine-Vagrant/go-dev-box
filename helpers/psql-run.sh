#!/usr/bin/env bash
# Run psql.

# Use database to connect to if provided.
db=''
if [ -n "$1" ]; then
  db="-d $1"
fi

echo 'Running psql...'
sudo -u postgres psql "$db"
