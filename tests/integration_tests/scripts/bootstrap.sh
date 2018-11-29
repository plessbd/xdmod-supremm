#!/bin/bash
# Bootstrap script that configures the SUPReMM-specific services and
# data. This script calls the main XDMoD integration test bootstrap
# do configure & start the core.

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
XDMOD_BOOTSTRAP=$BASEDIR/../../../../xdmod/open_xdmod/modules/xdmod/integration_tests/scripts/bootstrap.sh
REF_DIR=/root/assets/referencedata

set -e
set -o pipefail

if [ "$XDMOD_TEST_MODE" = "fresh_install" ];
then
    rm -rf /var/lib/mongo/*
    mongod -f /etc/mongod.conf
    ~/bin/importmongo.sh
    $XDMOD_BOOTSTRAP
    expect $BASEDIR/xdmod-setup.tcl | col -b
    aggregate_supremm.sh
fi

if [ "$XDMOD_TEST_MODE" = "upgrade" ];
then
    mongod -f /etc/mongod.conf
    $XDMOD_BOOTSTRAP
    aggregate_supremm.sh
fi
