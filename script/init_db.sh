#!/bin/sh

DB_FILE=db/upload.db

if [ -e ./db ]; then
	echo Creating $DB_FILE...

	if [ -e $DB_FILE ]; then
		echo $DB_FILE is already exists.
	else
		sqlite3 $DB_FILE <<__SQL__
	CREATE TABLE upload (
		id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		md5 TEXT NOT NULL,
		fname TEXT NOT NULL,
		download INTEGER NOT NULL DEFAULT 0
	);
__SQL__
		echo Done.
	fi
else
	echo Usage : script/init_db.sh
fi
