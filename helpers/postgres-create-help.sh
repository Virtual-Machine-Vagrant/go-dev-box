#!/usr/bin/env bash
# Print commands to create PostgreSQL db, user and grant privileges

echo 'Create PostgreSQL database:'
echo 'postgres=# CREATE DATABASE myproject;'

echo 'Create PostgreSQL user:'
echo "postgres=# CREATE USER myproject WITH PASSWORD 'password';"

echo 'Grant privileges:'
echo "postgres=# GRANT ALL PRIVILEGES ON DATABASE myproject TO myproject;"

sudo -u postgres psql
