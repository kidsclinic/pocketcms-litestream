#!/bin/bash
set -e

# Restore the database if it does not already exist.
if [ -f /pb_data/data.db ]; then
	echo "Database already exists, skipping restore"
else
	echo "No database found, restoring from replica if exists"
	litestream restore -if-replica-exists -o /pb_data/data.db "${REPLICA_URL}"
fi

# Run litestream with your app as the subprocess.
exec litestream replicate -exec "/usr/local/bin/pocketcms --dir /pb_data serve --http 0.0.0.0:8090"
