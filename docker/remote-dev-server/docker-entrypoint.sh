#!/bin/sh -eux
# jetbrains-remote-development-server/docker/docker-entrypoint.sh

if [ ! -d /root/projects/${PROJDIR} ]; then

    mkdir -p /root/projects/${PROJDIR}

    #Install plugin
    # time ide/bin/remote-dev-server.sh installPlugins ${PROJDIR} com.intellij.ja
    ide/bin/remote-dev-server.sh installPlugins /root/projects/${PROJDIR} com.jetbrains.php

    #Following features are disabled
    # time ide/bin/remote-dev-server.sh warm-up /root/projects/${PROJDIR}
    # export REMOTE_DEV_SERVER_JCEF_ENABLED=1

fi

exec "$@"
