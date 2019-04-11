#!/bin/bash

OPENHIM_CERT=openhim.cert
LETSENCRYPT_CERT=letsencrypt.cert
CA_CERT=/etc/ssl/certs/ca-certificates.crt
MYCERT=my.cert
API_URL=https://openhim.froidio.org:8008

if [ -f $MYCERT ]; then
    if [ !  -s $MYCERT ]; then
        echo $MYCERT exists, exiting
        exit 0
    fi
fi

#source VENV/bin/activate

if [ ! -f "openhim.cert" ] ; then
	echo "OpenHIM certificate not found, retrieving from $API_URL"
	python get_cert.py $API_URL  > $OPENHIM_CERT
else
	echo "OpenHIM certificate exists, checking"
	openssl x509 -in $OPENHIM_CERT -text | grep CN
fi
if [ ! -s $OPENHIM_CERT ] ; then
    echo "OpenHIM server certificate empty"
    exit 1
fi

if [ ! -f "letsencrypt.cert" ] ; then
	echo "letsencrypt root certificate not found, retrieving"
	python get_cert.py --no-verify  https://letsencrypt.org > $LETSENCRYPT_CERT
else
	echo "letsencrypt certificate exists, checking"
	openssl x509 -in $LETSENCRYPT_CERT -text | grep CN
fi
if [ !  -s $LETSENCRYPT_CERT ] ; then
    echo "letsencrypt certificate empty"
    exit 1
fi

if [ ! -f "/etc/ssl/certs/ca-certificates.crt" ] ; then
	echo "CA certificates not found - please add /etc/ssl/certs/ca-certificates.crt manually"
	exit 1
fi

echo "Concatenating certificates"
echo  $CA_CERT $LETSENCRYPT_CERT $OPENHIM_CERT

cat $CA_CERT $LETSENCRYPT_CERT $OPENHIM_CERT > $MYCERT

echo "Verifying $MYCERT"
openssl verify $MYCERT

