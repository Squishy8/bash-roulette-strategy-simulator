#!/bin/bash

declare -a myArray=(1 2 3 4)

number=1

echo -e "number is $number"

char="eight"

echo -e "\nchar is $char (string)"

declare -i number2=2 #In this case, the variable was declared as an integer, therefore if at any point in the algorithm is it changed, it will only accept and interpret integers.

echo -e "\nnumber2 was declared as an integer, and it is $number2"

char=2.0 #On the other hand, if we do not declare the type of variable using "declare", then the variable will take in any data type. That is why we can modify the contents of the "char" variable from a string to a float without any errors

echo -e "\nNow, char is $char (float)"

number2=True

echo -e "\nnumber2 was declared as an integer but is trying to store a boolean, it is shown as $number2 because it can not interpret this data type"

number2="hello"

echo -e "\nnumber2 was declared as an integer but is trying to store a string, it is shown as $number2 because it can not interpret this data type"

number2=2.1

echo -e "\nnumber2 was declared as an integer but is trying to store a float, it is shown as $number2 because it can not interpret this data type"

echo -e "\n$myArray" #This will only output the firste element of an array

echo -e "\n${myArray[@]}" #This allows us to show every element contained inside an array

#This is another way to list the contained elements of an array using a "for" loop
for element in ${myArray[@]}; do
    echo -e "\n [+] Element: $element"
done

#If we would want to list the elements and consider their positions, we would declare a variable that increments its value by 1 on each iteration

declare -i position=0
for element in ${myArray[@]}; do
    echo -e "\n [+] Element[$position]: $element"
    let position+=1
done

#If we want to know the amount of elements contained inside an array, we would insert a #

echo ${#myArray[@]}

#If we would want to add the first element and the last element, then we would do it as follows (whithout using ${myArray[-1]}):

numberOfElements=${#myArray[@]}

lastElement=${myArray[$(($numberOfElements-1))]}

firstElement=${myArray[0]}

sumOfElements=$(($lastElement+$firstElement))

echo $sumOfElements

#We could also achieve the previous task with the following logic:

lastElement=${myArray[-1]} #Negative numbers represent the "backwards" way of counting elements inside an array. In our case, as an example, the element in the position 0 would also be in the position -4 if we count backwards.

firstElement=${myArray[-4]}

sumOfElements=$(($firstElement+$lastElement))

echo $sumOfElements

#To append new elements to the end of the array we use the following logic:

myArray+=(5)

echo ${myArray[@]}

#To remove elements from the array we use the following logic...BUT THERE IS A CATCH

unset myArray[0]
unset myArray[-1] #We remove the first and last element from the array

#Here we run into a problem: Right now, the array contains 2 3 4, in which case the following command should output the number3 since it is in the position #1, but we see that the remaining numbers maintain their previous position numbers. This does not happen when adding new elements.
echo ${myArray[1]}

#To fix the previous error, we need to re asign this new array to the variable myArray

myArray=(${myArray[@]}) #Since we are asigning a new array we have to wrap the elements inside parenthesis
echo ${myArray[1]}

