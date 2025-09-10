#!/usr/bin/env bash

set -e

TF_ENV=$1
shift # Shift arguments to the left, so now $1 is "init", "apply", etc.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR

if [ $# -gt 0 ]; then
    if [ "$1" == "init" ]; then
        terraform -chdir=./$TF_ENV init -backend-config=../tf-backends/backend-$TF_ENV.tf
    else
        terraform -chdir=./$TF_ENV "$@"
    fi
fi

cd -