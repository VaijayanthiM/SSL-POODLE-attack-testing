#!/bin/bash
#####################################################################################
#
# ssl3_cipher_check.sh - Determine which SSL 3.0 ciphers, if any, are supported by
#                        a targeted server.
#
# Author  - Lamar Spells (lamar_spells@symantec.com)
#Test
#####################################################################################

if [ $# -lt 1 ] ; then
   echo "USAGE: `basename $0` <ip> [port]"
   exit 1
fi

if [ $# -eq 1 ] ; then
  SERVER=${1}:443
else
  SERVER=${1}:${2}
fi
DELAY=1

echo "Testing $SERVER for support of SSL3.0 ..."

result=`echo -n | openssl s_client -connect $SERVER -ssl3 2>&1`
if [[ "$result" =~ "New, TLSv1/SSLv3, Cipher is" ]] ; then
  echo "YES - SSL 3.0 support detected on $SERVER"
  exit 1  
else
  if [[ "$result" =~ ":error:" ]] ; then
    error=`echo -n $result | cut -d':' -f6`
    echo NO SSL 3.0 support detected on $SERVER \($error\)
    exit 0
  else
    echo "ERROR:  UNKNOWN RESPONSE: $result"
    exit 255
  fi
fi

