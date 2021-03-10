#!/bin/bash

TMPFILE=`mktemp`
wget --show-progress -q - $1 -O $TMPFILE
unzip -d $2 $TMPFILE
rm $TMPFILE
