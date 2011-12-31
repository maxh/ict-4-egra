#!/bin/sh

# USAGE
# ./updatePassage.sh file1 file2
 
# USAGE EXAMPLE
# ./updatePassage.sh NewPassage.txt Component6.xml

# DESCRIPTION
# Replaces the letters in a component 6 XForms file. The xml file must be manually adjusted to accomodate a story with more or less than 60 letters.

# ARGUMENTS
# $1 = file1 = a text file with the passage
# $2 = file2 = an EGRA Word XForms survey

i=1
l=$(awk '{print $1}' "$1")
until [ ${#l} -eq 0 ]
do
    if [ $i -lt 10 ]
    then
	echo "0$i = $l"
	sed -i temp 's/>0'"$i"': .*</>0'"$i"': '"$l"'</' "$2"
    else
	echo "$i = $l"
	sed -i temp 's/>'"$i"': .*</>'"$i"': '"$l"'</' "$2"
    fi
    i=$(($i+1))
    l=$(awk '{print $x}' x=$i "$1")
done