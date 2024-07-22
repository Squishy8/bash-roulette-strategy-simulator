#!/bin/bash

#Colours from https://github.com/s4vitar/rpcenum$
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
orangeColour="\e[38;2;255;165;0m\033[1m"
maroonColour="\e[38;2;128;0;0m\033[1m"

function ctrl_c(){
    echo -e "\n\n[!] ${redColour}Saliendo...${endColour}\n"
    tput cnorm; exit 1
}

#CTRL+C
trap ctrl_c INT


function helPanel(){
    echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Use${endColour}\n"

    echo -e "\t${turquoiseColour}-m)${endColour} ${redColour}Amount of money that will be used to play.${endColour}"
    echo -e "\t${turquoiseColour}-t)${endColour} ${redColour}Technique that will be used to play.${endColour}"

    echo -e "\t\t${yellowColour}[+]${endColour} ${greenColour}M (Martingale)${endColour}"
    echo -e "\t\t${yellowColour}[+]${endColour} ${greenColour}R (Reverse Labouchere)${endColour}"

    exit 1
}

function martingala(){
    echo "Martingala"
}

while getopts "m:t:h" arg; do
case $arg in
    m) money="$OPTARG";;
    t) technique="$OPTARG";;
    h) helPanel;;
esac
done

#We verify that both the money and technique variables contain an argument
if [ $money ] && [ $technique ]; then
    if [ "$technique" == "M" ]; then
        martingala
    else 
        echo "NONO"
        helPanel
    fi
else
    helPanel
fi
