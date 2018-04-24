#!/bin/sh
set -e # Error Sensitive Mode, which will break out of the script in case of unexpected errors.

cd "/app/mailpile"
venv ./mp --set sys.http_host="0.0.0.0"