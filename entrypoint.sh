#!/bin/bash

set -e

REPO_URL=$REPO_URL
RUNNER_TOKEN=$RUNNER_TOKEN

echo "REPO_URL: $REPO_URL"
echo "RUNNER_TOKEN: $RUNNER_TOKEN"
echo "NAME: $NAME"

# [ -d "_work" ] || ./config.sh --url $REPO_URL --token $RUNNER_TOKEN --name $NAME --unattended --replace

./run.sh
