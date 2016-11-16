# dehydrated debian packaging script
Scripts and files to produce preconfigured debian packages for the let's encrypt 
project on the basis of dehydrated

Many thanks to https://github.com/lukas2511/dehydrated which provides a
small lightweight bash and curl script for let's encrypt

## Usage
to build a debian package you can either run *./build.sh* and answer the 
questions or create a file named *config.sh* with content like this:

    #!/bin/bash
    case $1 in
    	example1)
    		VARIANT="$1"
    		CONTACT="admin@example.org"
    		SSH_USER="cert@dns.example.org"
    		CA_URL="https://acme-staging.api.letsencrypt.org/directory"
    		#CA_URL="https://acme-v01.api.letsencrypt.org/directory"
    		;;
    	example2)
    		VARIANT="$1"
    		CONTACT="admin@example.org"
    		SSH_USER="cert@dns.example.org"
    		CA_URL="https://acme-staging.api.letsencrypt.org/directory"
    		#CA_URL="https://acme-v01.api.letsencrypt.org/directory"
    		;;
    	*)
    		unset VARIANT CONTACT SSH_USER CA_URL
    esac
    export VARIANT CONTACT SSH_USER CA_URL

Then you can run *./build.sh example1* to build a package with a specific
configuration automatically.

## What the package does during installation
 * after installation it generates an ssh-key for login on the DNS server
   to update the dns zone with the letsencrypt challenges
 * it mails the ssh public key to the contact address
 * it installs a cron job which checks the certificates every 4 days

## What needs to be done after installation
 * add the key to the authorized_keys file on the DNS server for
   zone updates
 * edit the file */etc/dehydrated/domains.txt* according to
   /usr/share/doc/dehydrated/README.md
 * edit the file */etc/dehydrated/install-cert.sh* to put the certificates
   to the correct locations and restart the services
 * manually run */etc/dehydrated/dehydrated -c* after the ssh key has
   been added to the DNS server to generate the first certificate and enable
   the cronjob
