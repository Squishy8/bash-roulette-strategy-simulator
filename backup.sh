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

function martingale(){
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current money count:${endColour} ${orangeColour}$ $money${endColour}"
    #The -n parameter lets there not be a line skipping after this echo
    echo -ne "${yellowColour}[+]${endColour} ${grayColour}How much money will you bet? -> ${endColour}" && read initialBet #The "read" command alows the user to input information
    echo -ne "${yellowColour}[+]${endColour} ${grayColour}On what would you like to bet continuously (even/odd)? -> ${endColour}" && read parImpar

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You will be playing with an initial bet of ${orangeColour}$initialBet${endColour} ${grayColour}on${endColour} ${orangeColour}$parImpar${endColour} ${endColour}"

    backupBet=$initialBet #We store the initial bet so we can reference it whenever the modification of initial bet inside the while loop requires us to retake the bet that started the game
    playCounter=1

    badPlayCounter=""

    topWin=0

    #infinite loop
    tput civis #Hide cursor
    while true; do
        money=$(($money-$initialBet))
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You just bet${endColour} ${orangeColour}$ $initialBet${endColour}${grayColour}, and currently have${endColour} ${orangeColour}$ $money${endColour}"
        sleep 0.02
        random_number="$(($RANDOM % 37))" #This variable will store a random number between 0 and 36. To execute computations in bash we need to wrap the operation between $(())

        echo -e "${yellowColour}[+]${endColour} ${grayColour}Number${endColour} ${turquoiseColour}$random_number ${endColour}"

        #Logical checker that verifies the value of the random number and compares it to the selected category.
        if [ ! "$money" -lt 0 ]; then
            if [ $(($random_number % 2)) -eq 0 ]; then
                if [ "$random_number" -eq 0 ]; then
                    #echo -e "${yellowColour}[!]${endColour}${redColour} You lost${endColour}"
                    
                    initialBet=$((initialBet*2))

                    badPlayCounter+="$random_number "

                    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You currently have${endColour} ${orangeColour}$ $money${endColour}"

                fi
                if [ "$parImpar" == "even" ] && [ "$random_number" -ne 0 ]; then

                    reward=$(($initialBet * 2))

                    #echo -e "${yellowColour}[!]${endColour}${greenColour} You just won${endColour}${orangeColour} $ $reward${endColour}"

                    money=$(($money + $reward))

                    badPlayCounter=""

                    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You currently have${endColour} ${orangeColour}$ $money${endColour}"

                    initialBet=$backupBet
                    
                elif [ "$random_number" -ne 0 ]; then
                    #echo -e "${yellowColour}[!]${endColour}${redColour} You lost${endColour}"

                    initialBet=$((initialBet*2))

                    badPlayCounter+="$random_number "

                    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You currently have${endColour} ${orangeColour}$ $money${endColour}"
                fi
            else
                if [ "$parImpar" == "odd" ]; then
                    reward=$(($initialBet * 2))

                    #echo -e "${yellowColour}[!]${endColour}${greenColour} You just won${endColour}${orangeColour} $ $reward${endColour}"

                    money=$(($money + $reward))

                    badPlayCounter=""

                    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You currently have${endColour} ${orangeColour}$ $money${endColour}"

                    initialBet=$backupBet
                else
                    #echo -e "${yellowColour}[!]${endColour}${redColour} You lost${endColour}"

                    initialBet=$((initialBet*2))

                    badPlayCounter+="$random_number "

                    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You currently have${endColour} ${orangeColour}$ $money${endColour}"
                fi
            fi
            
        else
            echo -e "\n${yellowColour}[!]${endColour} ${maroonColour}You're broke!!${endColour}"
            echo -e "There have been a total of $(($playCounter-1)) plays."
            echo -e "Consecutive bad plays causing a loss: [ $badPlayCounter ]"
            echo -e "Highest Win: $topWin"
            tput cnorm; exit 0
        fi
        let playCounter+=1 #This counter will allow us to know how many loops have gone by
        if [ "$topWin" -lt "$money" ]; then
            topWin=$money
        fi
    done
    tput cnorm
}

function inverselabrouchere(){
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current money count:${endColour} ${orangeColour}$ $money${endColour}" 

    echo -ne "${yellowColour}[+]${endColour} ${grayColour}On what would you like to bet continuously (even/odd)? -> ${endColour}" && read parImpar

    declare -a mySequence=(1 2 3 4)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Starting with sequence${endColour} ${orangeColour}[${mySequence[@]}]${endColour}"

    bet=$((${mySequence[0]}+${mySequence[-1]}))

    playCounter=0

    tput civis
    while true; do
        let playCounter+=1
        sleep 0.02
        random_number=$(($RANDOM % 37))
        let money-=$bet #We subtract the amount of money we bet to our total amount of money
        if [ ! "$money" -lt 0 ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Betting${endColour} ${orangeColour}\$$bet${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}You have${endColour} ${orangeColour}\$$money${endColour}"

            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Number${endColour} ${turquoiseColour}$random_number ${endColour}"

            if [ "$parImpar" == "even" ]; then
                if [ "$(($random_number % 2))" -eq 0 ] && [ ! "$random_number" -eq 0 ]; then

                    echo -e "${yellowColour}[!]${endColour} ${grayColour}El número es par,${endColour} ${greenColour}¡ganas!${endColour}"

                    reward=$(($bet*2))

                    let money+=$reward

                    echo -e "${yellowColour}[+] You have${endColour}${orangeColour} $money${endColour}"

                    mySequence+=($bet)
                    mySequence=(${mySequence[@]})

                    echo -e "${yellowColour}[+]${endColour} ${grayColour}New sequence:${endColour} ${orangeColour}[${mySequence[@]}]${endColour}"
                    
                    if [ "${#mySequence[@]}" -ne 1 ] && [ "${#mySequence[@]}" -ne 0 ]; then

                        #We update the value of our bet
                        bet=$((${mySequence[0]} + ${mySequence[-1]}))
                    elif [ "${#mySequence[@]}" -eq 1 ]; then
                        bet=${mySequence[0]}
                    else
                        echo -e "${redColour}[!] The sequence has ended...${endColour}"
                        mySequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Remaking sequence as${endColour}${orangeColour} ${mySequence[@]}${endColour}"
                    fi

                elif [ $(("$random_number" % 2)) -eq 1 ] || [ "$random_number" -eq 0 ]; then
                    if [ $(("$random_number" % 2)) -eq 1 ]; then
                        echo -e "${yellowColour}[!]${endColour} ${grayColour}${endColour} ${redColour}¡You Lost (odd)!${endColour}"
                    else
                        echo -e "${yellowColour}[!]${endColour} ${grayColour}${endColour} ${redColour}¡You Lost (0)!${endColour}"

                    fi
                    unset mySequence[0]
                    unset mySequence[-1] 2>/dev/null

                    mySequence=(${mySequence[@]})

                    echo -e "${yellowColour}[+]${endColour} ${grayColour}The new sequence is${endColour} ${orangeColour}[${mySequence[@]}]${endCollour}"

                    if [ "${#mySequence[@]}" -ne 1 ] && [ "${#mySequence[@]}" -ne 0 ]; then

                        #We update the value of our bet
                        bet=$((${mySequence[0]} + ${mySequence[-1]}))
                    elif [ "${#mySequence[@]}" -eq 1 ]; then
                        bet=${mySequence[0]}

                    else

                        echo -e "${redColour}[!] The sequence has ended...${endColour}"

                        mySequence=(1 2 3 4)

                        echo -e "${yellowColour}[+]${endColour} ${grayColour}Remaking sequence as${endColour}${orangeColour} [${mySequence[@]}]${endColour}"

                        bet=$((${mySequence[0]}+${mySequence[-1]}))

                    fi

                fi

            fi
        else
            echo -e "\n${yellowColour}[!]${endColour} ${maroonColour}You're broke!!${endColour}"
            echo -e "There have been a total of $(($playCounter-1)) plays."
            tput cnorm; exit 1
        fi

    done
    tput cnorm

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
        martingale
    elif [ "$technique" == "R"  ]; then
        inverselabrouchere
    else 
        echo "NONO"
        helPanel
    fi
else
    helPanel
fi

#Implement checkers that verify that the technique selection, odd/even selection and money amount are actually correct
