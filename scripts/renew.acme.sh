#!/bin/sh

if [ $# -ne 2 ]
then
    echo "Usage: $0 <domain> <wandev>"
    exit 1
fi

DOMAIN=$1
WAN=$2

ACMEHOME=/config/.acme.sh
WANIP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

/sbin/iptables -I WAN_LOCAL 2 -p tcp -m comment --comment TEMP_LETSENCRYPT -m tcp --dport 80 -j RETURN
$ACMEHOME/acme.sh --issue -d $DOMAIN --standalone --home $ACMEHOME --local-address $WANIP --keypath /tmp/server.key --fullchainpath /tmp/full.cer --reloadcmd /config/scripts/reload.acme.sh
/sbin/iptables -D WAN_LOCAL 2