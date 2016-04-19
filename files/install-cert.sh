#!/bin/bash

. /etc/letsencrypt/config.sh

DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" CHAINFILE="${4}"

# This file is called once for each certificate that has been
# produced. Here you might, for instance, copy your new certificates
# to service-specific locations and reload the service.
#
# Parameters:
# - DOMAIN
#   The primary domain name, i.e. the certificate common
#   name (CN).
# - KEYFILE
#   The path of the file containing the private key.
# - CERTFILE
#   The path of the file containing the signed certificate.
# - CHAINFILE
#   The path of the file containing the full certificate chain.

echo " ! Certificate installation not yet configured"
echo " ! edit /etc/letsencrypt/install-cert.sh"
echo " ! certificates and keys are in $(dirname $CERTFILE)/"
exit 1

# example
#cat "$CHAINFILE" > /etc/ssl/certs/cert.pem
#cat "$KEYFILE" > /etc/ssl/private/key.pem
#
#/usr/sbin/service nginx reload
#/usr/sbin/service exim4 restart
#/usr/sbin/service dovecot restart
