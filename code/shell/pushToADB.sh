#!/bin/sh

for i in $(ls -r "$1"/C*.xml)
do
    echo $i
    adb push "$i" /sdcard/odk/forms
done