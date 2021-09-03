#!/bin/sh

export PATH=$PATH:/usr/local/bin

>&2 echo "***************************"
>&2 echo "PATH=$PATH"
>&2 echo "***************************"

>&2 which containerd

sleep 1

exec "$@"

