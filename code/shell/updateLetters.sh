#!/bin/sh

# USAGE
# ./C1_UpdateLetters.sh file1 file2
 
# USAGE EXAMPLE
# ./C1_UpdateLetters.sh NewLetters.txt C1_LetterNameKnowledge.xml

# DESCRIPTION
# Replaces the letters in a Letter Name Knowledge form.

# ARGUMENTS
# $1 = file1 = a text file with 100 letters separated by spaces
# $2 = file2 = an EGRA Letter Knowledge XForms survey

for (( i=1; i<=100; i++ ))
do
    l=$(awk '{print $x}' x=$i $1) # read the ith letter from the input file
    if [ $i -lt 10 ]
    then
	echo "0$i = $l"
	sed -i temp 's/>0'"$i"': .</>0'"$i"': '"$l"'</' $2
    else
	echo "$i = $l"
	sed -i temp 's/>'"$i"': .</>'"$i"': '"$l"'</' $2
    fi
done