#!/bin/sh

# Default config file
CONFIG_FILE=/data/config.json;

# Check type
if [ "$STATUSD_MODE" = "MAILSERVER" ];then
    CONFIG_FILE=/data/configMailServer.json
fi

/usr/local/bin/statusd -register -log DEBUG -c $CONFIG_FILE -metrics
