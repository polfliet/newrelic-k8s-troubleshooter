#!/bin/bash

# Set the following environment variables:
# export NRIA_LICENSE_KEY=
# export NEW_RELIC_REGION=EU
# export HTTP_PROXY=

export http_proxy=$HTTP_PROXY
export https_proxy=$http_proxy

YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function prettyPrint {
    echo -e "${YELLOW}$1${NC}"
}

function prettyExec {
    echo -e "Command to execute:" $@
    $@
    echo
}

prettyPrint "Running with the following env vars:"
prettyPrint "\t NRIA_LICENSE_KEY: "$NRIA_LICENSE_KEY
prettyPrint "\t NEW_RELIC_REGION: "$NEW_RELIC_REGION
prettyPrint "\t HTTP_PROXY: "$HTTP_PROXY
prettyPrint

###################################
# 1. Generic network connectivity #
###################################

# Test network connectivity to the outside world
# Note: This will not work if the customer is using a proxy
prettyPrint "Test 1 - Outbound network connectivity"
prettyExec ping 8.8.8.8 -c 3

# Test DNS resolution
prettyPrint "Test 2 - DNS resolution"
prettyExec nslookup newrelic.com

#####################
# 2. New Relic Logs #
#####################

# Check /var/log/containers
prettyPrint "Test 3 - Check log files (/var/log is mounted in this container)"
prettyExec ls -lh /var/log/containers

# Try sending a log line manually
# Output should be something like {"requestId":"2d96e8f4-0038-b000-0000-017394bf8267"}
prettyPrint "Test 4 - Send log message"

LOG_API="log-api.newrelic.com"
if [ "$NEW_RELIC_REGION" == "EU" ]; then
    LOG_API="log-api.eu.newrelic.com"
fi
TIMESTAMP=`date +'%s'`
echo "Command to execute: " curl -v "https://$LOG_API/log/v1" \
    -H "X-License-Key: $NRIA_LICENSE_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"timestamp\": \"$TIMESTAMP\", \"message\": \"This is a test message from the New Relic troubleshooter\"}"
curl -v "https://$LOG_API/log/v1" \
    -H "X-License-Key: $NRIA_LICENSE_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"timestamp\": \"$TIMESTAMP\", \"message\": \"This is a test message from the New Relic troubleshooter\"}"

#############
# 3. TODO   #
#############

# Potentially check other things here as well

