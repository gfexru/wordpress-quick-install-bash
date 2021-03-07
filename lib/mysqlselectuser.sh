#!/bin/bash

ROOTUSERMYSQL=$1
ROOTPASSMYSQL=$2

echo "select user, host from mysql.user;" | mysql -u $ROOTUSERMYSQL -p$ROOTPASSMYSQL