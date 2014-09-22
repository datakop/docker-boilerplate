#!/bin/bash
set -e
echo "1 START!!!!"
if [ "$1" = 'postgres' ]; then
	echo "2 SHOWN!!!!"
	chown -R postgres "$PGDATA"
	
	echo "3 $PGDATA!!!!"
	if [ -z "$(ls -A "$PGDATA")" ]; then
		echo "4 initdb!!!!"
		gosu postgres initdb
		

		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf
		
		{ echo; echo 'host all all 0.0.0.0/0 trust'; } >> "$PGDATA"/pg_hba.conf
	fi
	echo "5 gosu postgres $@"
	# exec gosu postgres "$@"
	echo "6 $@HHHHHHH!!!!"
fi

exec "$@"
