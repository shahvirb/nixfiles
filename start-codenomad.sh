#!/usr/bin/env bash
pkill -f codenomad 2>/dev/null
sleep 3
cd ~/
npx @neuralnomads/codenomad --password test --host 0.0.0.0 &
