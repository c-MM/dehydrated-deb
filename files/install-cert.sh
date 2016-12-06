#!/bin/bash

. /etc/dehydrated/config

DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" FULLCHAINFILE="${4}" CHAINFILE="${5}" TIMESTAMP="${6}"

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
# - FULLCHAINFILE
#   The path of the file containing the full certificate chain.
# - CHAINFILE
#   The path of the file containing the full certificate chain.
# - TIMESTAMP
#   Timestamp when the specified certificate was created.

echo " ! Certificate installation not yet configured"
echo " ! edit /etc/dehydrated/install-cert.sh"
echo " ! certificates and keys are in $(dirname $CERTFILE)/"
exit 1

# example
#cat "$FULLCHAINFILE" > /etc/ssl/certs/cert.pem
#cat "$KEYFILE" > /etc/ssl/private/key.pem
#chown root.ssl-cert /etc/ssl/private/key.pem
#chmod 640 /etc/ssl/private/key.pem
#
#/usr/sbin/service nginx reload
#/usr/sbin/service exim4 restart
#/usr/sbin/service dovecot restart
