#!/bin/sh

KEYS=$(find /etc/ssh -name 'ssh_host_*_key')
[ -z "$KEYS" ] && ssh-keygen -A >/dev/null 2>/dev/null

[ "${USE_METADATA:-}" = "true" ] && /usr/bin/apply-metadata.sh

exec /usr/sbin/sshd -D -e
