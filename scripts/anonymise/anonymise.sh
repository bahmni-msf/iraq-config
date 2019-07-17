#!/bin/sh
set -e -x

export BACKUP_DB_NAME =
mysql -uroot -ppassword $BACKUP_DB_NAME < deidentify_openmrs.sql
