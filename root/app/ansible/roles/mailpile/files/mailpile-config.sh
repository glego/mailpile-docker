#!/bin/sh
set -e # Error Sensitive Mode, which will break out of the script in case of unexpected errors.

# Make mailpile owner of the data
chown mailpile: /mailpile-data/ -R