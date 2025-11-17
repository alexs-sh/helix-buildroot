#!/bin/bash

MODE=""
PACKAGE_NAME=helix
CONFIG_FILE=${PACKAGE_NAME}.config
CMD="./utils/test-pkg -p $PACKAGE_NAME -c $CONFIG_FILE"

if [ "$#" -ge 1 ]; then
   MODE=$1
fi


set -e
. "$HOME/.cargo/env"


cp -f configs/$CONFIG_FILE buildroot/
cd buildroot

if [ "$MODE" = "all" ]; then
  CMD+=" --all"
fi

export FORCE_UNSAFE_CONFIGURE=1
eval "$CMD"
