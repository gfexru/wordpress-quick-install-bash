#!/bin/bash

ROOTUSERMYSQL=$1
ROOTPASSMYSQL=$2
DBNAME=$3

echo "DROP DATABASE $DBNAME;" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL