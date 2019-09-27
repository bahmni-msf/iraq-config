#!/bin/sh
set -e -x

mysql -uroot -ppassword openmrs < /var/www/bahmni_config/scripts/anonymise/deidentify_openmrs.sql
