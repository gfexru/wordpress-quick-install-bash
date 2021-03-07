#!/bin/bash
# проверка существования каталога
LSDIR=$1

if [ -e $LSDIR ]; then

echo "Каталог $LSDIR существует"

else

#mkdir $CREATEDIR
echo "Каталог $LSDIR существует"

fi