#!/bin/bash

ROOTUSERMYSQL=$1
ROOTPASSMYSQL=$2

echo "SHOW DATABASES;" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL