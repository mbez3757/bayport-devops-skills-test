#!/bin/bash

#Get the directory names and add it to directories.list
ls -d */ > directories.list

#Insert "one line's one" at begining of directories.list
sed -i "1iline one's line" directories.list

#Display first three lines to terminal
head -3 directories.list
 
#Print the firtst three lines x number of times
##Check if a parameter was set
if [ -z $1 ];
then
       	echo "error: A parameter value was not specified" >&2; exit 1
else
	number_of_iterations=$1
fi

##Check if a parameter is a number
re='^[0-9]+$' 
if ! [[ $number_of_iterations =~ $re ]];
then
       	echo "error: The parameter is not a number" >&2; exit 1
fi

while [ $number_of_iterations -gt 0 ]
do	
	head -3 directories.list
	number_of_iterations=$(( $number_of_iterations - 1 ))
done
