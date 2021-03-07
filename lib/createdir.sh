#!/bin/bash
# проверка существования каталога и кго создания при отсутствии
CREATEDIR=$1

if [ -e $CREATEDIR ]; then

echo "Каталог $CREATEDIR существует"

else

mkdir $CREATEDIR

fi
