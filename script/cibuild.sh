#!/usr/bin/env bash
set -e # halt script on error

ALGOLIA_API_KEY=${ALGOLIA_API_KEY_CI} bundle exec jekyll algolia
bundle exec jekyll build
bundle exec rake test