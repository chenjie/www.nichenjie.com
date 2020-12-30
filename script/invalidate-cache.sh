#!/usr/bin/env bash
set -e # halt script on error

aws cloudfront create-invalidation --distribution-id EJQURJXTSMRAR --paths "/*"
