#!/bin/sh

# USAGE
# ./updateWords.sh file1 file2
 
# USAGE EXAMPLE
# ./updateWords.sh NewWords.txt Component4.xml

# DESCRIPTION
# Replaces the letters in a word reading or unfamiliar nonword decoding exercise

# ARGUMENTS
# $1 = file1 = a text file with 50 words or nonwords separated by spaces
# $2 = file2 = an EGRA Word or Nonword XForms survey

for (( i=1; i<=50; i++ ))
do
    l=$(awk '{print $x}' x=$i "$1") # read the ith word from the input file
    if [ $i -lt 10 ]
    then
	echo "0$i = $l"
	sed -i temp 's/>0'"$i"': .*</>0'"$i"': '"$l"'</' "$2"
    else
	echo "$i = $l"
	sed -i temp 's/>'"$i"': .*</>'"$i"': '"$l"'</' "$2"
    fi
done