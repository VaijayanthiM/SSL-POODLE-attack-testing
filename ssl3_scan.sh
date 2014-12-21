#!/bin/bash
#####################################################################################
#
# ssl3_scan.sh - Wrapper to run ssl3_cipher_check.sh to scan / test a network range
#
# Author  - Lamar Spells (lamar_spells@symantec.com)
#
#####################################################################################

SSL3_CHECK_CIPHERS="./ssl3_cipher_check.sh"

if [ $# -lt 1 ] ; then
   echo "USAGE: `basename $0` <ip-range>"
   exit 1
fi

if [ $# -eq 1 ] ; then
  IP_RANGE=${1}
fi

echo "Beginning test... please be patient..."
nmap -PN -sT -p 443,4443,14443,8443,18443 -v  $IP_RANGE | grep ^Discovered | awk '{printf("%s:%s\n",$NF,$4)}'  | sed -e 's!/tcp!!g' | while read hn
do
   retcd=0
   $SSL3_CHECK_CIPHERS $hn > /dev/null 2>&1
   retcd=$?

   if [ $retcd -eq 0 ] ; then
      echo "$hn - SSL3.0 NOT supported"
   else 
      if [ $retcd -eq 1 ] ; then
         echo "$hn - SSL3.0 supported"
      else
         echo "$hn - Error in connection"
      fi
   fi
done
exit 0

