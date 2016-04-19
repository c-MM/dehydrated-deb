#!/bin/bash

if [ -x config-local.sh ] ; then
	. config-local.sh "$1"
elif [ -x config.sh ] ; then
	. config.sh "$1"
fi

[ -z "$VARIANT"  ] && read -e -i "example"             -p "Enter tag for package name         : " VARIANT
[ -z "$CONTACT"  ] && read -e -i "certs@example.com"   -p "Enter contact email address        : " CONTACT
[ -z "$SSH_USER" ] && read -e -i "cert@ns.example.com" -p "Enter ssh username and server      : " SSH_USER
[ -z "$CA_URL"   ] && read -N 1                        -p "Use letsencrypt staging api? (y/n) : " CA_URL && echo

if [ "$CA_URL" = "y" -o "$CA_URL" = "Y" ] ; then
	CA_URL="https://acme-staging.api.letsencrypt.org/directory"
elif [ "$CA_URL" = "n" -o "$CA_URL" = "N" ] ; then
	CA_URL="https://acme-v01.api.letsencrypt.org/directory"
elif [ "$CA_URL" = "\r" ] ; then
	CA_URL="https://acme-staging.api.letsencrypt.org/directory"
	[ "$VARIANT" = "example" ] && VARIANT="example-test"
fi

sed -e "s/^\(Package: letsencrypt\).*/\1-$VARIANT/" > debian/control < debian/control.tmpl

export CONTACT SSH_USER CA_URL

dpkg-buildpackage -us -uc -tc -b
