#!/bin/bash

[ -d /etc/dehydrated/certs ] || exit 0

. /etc/dehydrated/config

if [ -r /var/lib/dehydrated/cron_run ] ; then
	find /var/lib/dehydrated/ -maxdepth 1 -name cron_run -mmin +$((60 * 24 * 4 - 1)) \
	| grep -q cron_run || exit 0
fi

touch /var/lib/dehydrated/cron_run

tmpfile="$( mktemp -t dehydrated.out.XXXXXXXXXX )"

exec >"$tmpfile" 2>&1 < /dev/null

/etc/dehydrated/dehydrated -c

if [ $? -ne 0 ] ; then
	cat "$tmpfile" | mail -s "dehydrated failed on $(hostname -f)" $CONTACT_EMAIL
fi
rm -f "$tmpfile"
