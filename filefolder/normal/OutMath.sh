#!/bin/bash

inputFile=$1

currentLineString="currentline"
currentLineNumber="1"
increaseNumber="1"

resultNumber="0"

contains() {

	string=$1
    substring=$2

	if [[ "$string" == *"$substring"* ]]; then
    
    	echo ""

    else

    	echo $string

	fi
}


while [[ -n $currentLineString ]]; do

	echo "DateNumber :$currentLineNumber"

	currentLineString=`awk "NR==$currentLineNumber {print; exit}" $inputFile`

	echo "Date :$currentLineString"

	tempNumber="0"
	currentSet="2"
	while [[ -n $currentSet ]]; do
		
		for i in 'T' 'F' 'S'; do

			currentSetNumber=$(echo $currentLineString | awk -F "${i}" '{gsub(" ","'${i}'"); print '"\$${currentSet}"'}' )

			checkedSetNumber=$currentSetNumber

			for j in 'T' 'F' 'S'; do

				checkedSetNumberTemp=`contains $currentSetNumber $j`

				if [[ -z $checkedSetNumberTemp ]]; then
					checkedSetNumber=""
				fi

			done

			if [[ -n $checkedSetNumber ]]; then
				
				echo "Out  :$currentSetNumber"
				#resultNumber="`expr $resultNumber + $currentSetNumber`"

				resultNumber=$(echo $resultNumber $currentSetNumber | awk '{print $1 + $2}')

			fi

		done

		if [[ "${tempNumber}" == "${resultNumber}" ]]; then

			currentSet=""

		else

			currentSet="`expr $currentSet + $increaseNumber`"

		fi

		tempNumber=$resultNumber

	done


	echo "Result Temp :$resultNumber"

	currentLineNumber="`expr $currentLineNumber + $increaseNumber`"

done


echo "Result >>> $resultNumber"


