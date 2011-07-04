#!/bin/sh

DB_SQL=db/init.sql
DB_FILE=db/upload.db

if [ -e $DB_FILE ]; then
	echo $DB_FILE is already exists.
	echo Usage : script/init_db.sh
	exit
fi

if [ ! -e $DB_SQL ]; then
	echo $DB_SQL is not exists.
	echo Usage : script/init_db.sh
	exit
fi

echo Creating $DB_FILE...
cat $DB_SQL | sqlite3 $DB_FILE
echo Done.
