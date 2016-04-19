#!/bin/bash

[ -d /etc/letsencrypt/certs ] || exit 0

. /etc/letsencrypt/config.sh

if [ -r /var/lib/letsencrypt/cron_run ] ; then
	find /var/lib/letsencrypt/ -maxdepth 1 -name cron_run -mmin +$((60 * 24 * 4 - 1)) \
	| grep -q cron_run || exit 0
fi

touch /var/lib/letsencrypt/cron_run

tmpfile="$( mktemp -t letsencrypt.out.XXXXXXXXXX )"

exec >"$tmpfile" 2>&1 < /dev/null

/etc/letsencrypt/letsencrypt.sh -c

if [ $? -ne 0 ] ; then
	cat "$tmpfile" | mail -s "letsencrypt failed on $(hostname -f)" $CONTACT_EMAIL
fi
rm -f "$tmpfile"
