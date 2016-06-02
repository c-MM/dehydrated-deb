#!/bin/bash

. /etc/letsencrypt/config.sh

function deploy_challenge {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    # This hook is called once for every domain that needs to be
    # validated, including any alternative names you may have listed.
    #
    # Parameters:
    # - DOMAIN
    #   The domain name (CN or subject alternative name) being
    #   validated.
    # - TOKEN_FILENAME
    #   The name of the file containing the token to be served for HTTP
    #   validation. Should be served by your web server as
    #   /.well-known/acme-challenge/${TOKEN_FILENAME}.
    # - TOKEN_VALUE
    #   The token value that needs to be served for validation. For DNS
    #   validation, this is what you want to put in the _acme-challenge
    #   TXT record. For HTTP validation it is the value that is expected
    #   be found in the $TOKEN_FILENAME file.

    echo " + HOOK: connecting to DNS server $SSH_USER"
    echo "deploy" "$@" | $SSH_CMD $SSH_USER 2>/dev/null || exit 1
    echo " + HOOK: disconnected from DNS server"
}

function clean_challenge {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"

    # This hook is called after attempting to validate each domain,
    # whether or not validation was successful. Here you can delete
    # files or DNS records that are no longer needed.
    #
    # The parameters are the same as for deploy_challenge.

    echo " + HOOK: connecting to DNS server $SSH_USER"
    echo "clean" "$@" | $SSH_CMD $SSH_USER 2>/dev/null || exit 1
    echo " + HOOK: disconnected from DNS server"
}

function deploy_cert {
    local DOMAIN="${1}" KEYFILE="${2}" CERTFILE="${3}" CHAINFILE="${4}"

    # cleanup files from failed atempts
    for i in $(find /etc/letsencrypt/certs/ -type f -size 0 -name cert\*.pem) ; do
	rm -f $i $(echo "$i" |  sed -e 's/pem$/csr/') $(echo "$i" | sed -e 's/\/cert-/\/privkey-/')
    done

    # This hook is called once for each certificate that has been
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

    /etc/letsencrypt/install-cert.sh "${DOMAIN}" "${KEYFILE}" "${CERTFILE}" "${CHAINFILE}"
}

function unchanged_cert {
    true
}

HANDLER=$1; shift; $HANDLER $@
