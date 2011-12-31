#!/bin/sh

# USAGE
# ./addComponents.sh file1 file2 ...

# USAGE EXAMPLE
# ./addComponents.sh EGRA_template.xml C0_StudentInformation.xml C1_LetterNameKnowledge.xml

# DESCRIPTION
# Adds the components described in file2, file3, to fileN to the EGRA assessment in file1.

# ARGUMENTS
# $1 = EGRA template file
# $2 to $n = XForms files for the EGRA components


egra_file="$1"
shift # now the remaining arguments are all component forms to be added

# finds the line number of the instance of the argument in the component file
# args: (regex to find)
function get_line_number () {
    echo $(egrep -n "$1" "$component_file" | awk '{print $1}' | sed 's/://')
}

# add appends the argument as a line to the current section in the egra_file
# reqs: $section must be set
# args: (line to add)
function add_line ()
{
    # the -i flag adds whitespace to the front of the line
    if [ "$1" = "-i" ]; then
	line=$2
	ws="\1" # backreference whitespace in sed command
    else # don't add whitespace
	line="$1"
	ws=""
    fi
    echo "Adding:" "$line"
    line=$(echo "$line" | sed 's/[\/\\\&]/\\&/g') # escape chars
    sed -Ei tmp 's/^([ \'$'\t'']*)<!--'"$section"'-->/'$ws''"$line"'\'$'\n''&/' "$egra_file"
}

# copies a section from the component file to the EGRA file
# requires $section, $start, and $end to be set properly
function add_section ()
{
    add_line -i "<!--START:"$id"-->"
    # add group tag and label for body section
    if [ "$section" = "body" ]; then
	add_line -i "<group>"
	add_line -i "<label>$label</label>"
    fi
    for (( i=$start+1; i<$end; i++ ))
    do
	line=$(sed -n $i,"$i"p "$component_file") # read a line
	if [ "$section" = "body" ]; then
	    add_line "   $line" # now nested in the <group> tag
	else
	    add_line "$line"
	fi
    done
    # add closing group tag for body section
    if [ "$section" = "body" ]; then
	add_line -i "</group>"
    fi
    add_line -i "<!--END:"$id"-->" 
}

function add_component ()
{
    # extract id and label from the component.xml file
    id=$(sed -En 's/^.*<data id="([^"]*)">/\1/p' "$component_file" | tr -d "\r")
    label=$(sed -En 's/^.*<h:title>([^<]*)<\/h:title>/\1/p' "$component_file" | tr -d "\r")

    # copy the data section
    section=data
    start=$(get_line_number "<data")
    end=$(get_line_number "</data>")
    add_section
 
    # copy the translation section
    section=translation
    start=$(get_line_number "<translation")
    end=$(get_line_number "</translation")
    add_section

    # copy the bind section
    section=bind
    start=$(get_line_number "</itext")
    end=$(get_line_number "</model")
    add_section

    # copy the group section
    section=body
    start=$(get_line_number "<h:body>")
    end=$(get_line_number "</h:body>")
    add_section
}

while (( "$#" ))
do
    component_file="$1"
    add_component
    shift
done

# remove carriage returns
tr -d "\r" < "$egra_file" > "$egra_file"tmp
mv "$egra_file"tmp "$egra_file"
