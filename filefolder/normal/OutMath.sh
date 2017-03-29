#!/bin/bash

myvar=$(expr 1 + 1)

echo $myvar


awk -F 'T' '{gsub(" ","T"); print $3}' text.txt

