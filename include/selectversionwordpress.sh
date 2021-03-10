#!/bin/bash

#Choice install Wordpress
echo
echo -e "\e[1;31;42m$LANGSTRSELECTWPVER\e[0m"
echo
PS3="$LANGSTRSELECTWPVER"
echo
select SELECTWPVER in "latest" "choice" "beta" "RC" "nightly"
do
  echo
  echo -e "\e[1;34;4m$LANGSTRYOUCHOISE $SELECTWPVER\e[0m"
  echo
  break
done
#
#Проверка выбора
if [[ -z "$SELECTWPVER" ]];then
    echo  -e "\e[31m$LANGSTRNOTENTER SELECTWPVER\e[0m"
    exit 1
fi

#Get version choise wordpress
if [ $SELECTWPVER == "choice" ]; then
    #Choice install Wordpress
    read -p "$LANGSTRCHOICEVERWP" CHOICEVERWP
    #Проверка выбора
        if [[ -z "$CHOICEVERWP" ]];then
        echo  -e "\e[31m$LANGSTRNOTENTER CHOICEVERWP\e[0m"
        exit 1
	fi
fi

#Get version beta wordpress
if [ $SELECTWPVER == "beta" ]; then
    #Choice install Wordpress
    read -p "$LANGSTRCHOICEBETAVERWP" CHOICEBETAVERWP
    #Проверка выбора
        if [[ -z "$CHOICEBETAVERWP" ]];then
        echo  -e "\e[31m$LANGSTRNOTENTER CHOICEBETAVERWP\e[0m"
        exit 1
	fi
    #Choice install Wordpress
    read -p "$LANGSTRBETAVERWP" BETAVERWP
    #Проверка выбора
        if [[ -z "$BETAVERWP" ]];then
        echo  -e "\e[31m$LANGSTRNOTENTER BETAVERWP\e[0m"
        exit 1
	fi
fi

#Get version RC wordpress
if [ $SELECTWPVER == "RC" ]; then
    #Choice install Wordpress
    read -p "$LANGSTRCHOICERCVERWP" CHOICERCVERWP
    #Проверка выбора
        if [[ -z "$CHOICERCVERWP" ]];then
        echo  -e "\e[31m$LANGSTRNOTENTER CHOICERCVERWP\e[0m"
        exit 1
	fi
    read -p "$LANGSTRRCVERWP" RCVERWP
    #Проверка выбора
        if [[ -z "$RCVERWP" ]];then
        echo  -e "\e[31m$LANGSTRNOTENTER RCVERWP\e[0m"
        exit 1
	fi

fi
