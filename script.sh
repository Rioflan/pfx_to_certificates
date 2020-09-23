#!/bin/bash

if [ -z "$1" ]; then
  1>&2 echo "Need PFX path as argument"
  exit 1
fi

read -sp 'Enter PFX import password: ' IMPORT_PASSWORD
echo

openssl pkcs12 -in $1 -nocerts -nodes  -passin pass:$IMPORT_PASSWORD | sed -n /BEGIN/,/END/p >privkey.pem
openssl rsa -in privkey.pem -out privkey_rsa.pem >/dev/null
openssl pkcs12 -in $1 -clcerts -nokeys -passin pass:$IMPORT_PASSWORD | sed -n /BEGIN/,/END/p >cert.pem
openssl pkcs12 -in $1 -cacerts -nokeys -passin pass:$IMPORT_PASSWORD | sed -n /BEGIN/,/END/p >chain.pem
cat cert.pem >fullchain.pem
cat chain.pem >>fullchain.pem
