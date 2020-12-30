#!/usr/bin/env bash
set -e # halt script on error

aws s3 rm s3://www.nichenjie.com --recursive --region ap-east-1
