#!/usr/bin/env bash
set -e # halt script on error

aws cloudfront create-invalidation --distribution-id E3U0JG8KK5Y4U6 --paths "/*"