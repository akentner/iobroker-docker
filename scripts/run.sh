#!/bin/bash

if [ -f .install_host ];
then
    sed -i "s/$(cat .install_host)/$(hostname)/g" iobroker-data/objects.json
    rm -f .install_host
fi

iobroker add admin --enabled --port 8090

/usr/bin/node node_modules/iobroker.js-controller/controller.js
