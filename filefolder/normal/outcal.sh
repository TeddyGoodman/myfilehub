#!/bin/bash

inputFile=$1

exitCheckString="6"

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

containsNumber() {

	if [[ $1 =~ ^[0-9]+$ ]]
	then
		echo "$1"
	else
		echo ""
	fi

}

isVariableFloat() {

	inputNumber="$1"

	echo $inputNumber | grep "^[0-9]*[.][0-9]*$"
	val=`echo $?`
	if [[ $val == 0 ]]
	then
    	echo "$inputNumber"
	else
    	echo ""
	fi
}

isVariableInteger() {

	local input="$1"

	if [[ $1 =~ ^[0-9]+$ ]]
	then
    	echo $1
	else
    	echo ""
	fi
}

OutDefinitionArray=( "F" "E" "S" "T" "H" "M" )


while [[ $exitCheckString != "0" ]]; do

	currentLineString=`awk "NR==$currentLineNumber {print; exit}" $inputFile`

	if [[ -n $currentLineString ]]; then

		echo "Older :$currentLineNumber"
		
		echo "Date :$currentLineString"

		tempNumber="0"
		currentSet="2"
		while [[ -n $currentSet ]]; do
		
			for i in 'F' 'E' 'S' 'T' 'H' 'M' ; do

				#currentSetNumber=$(echo $currentLineString | awk -F "${i}" '{gsub(" ","'${i}'"); print '"\$${currentSet}"'}' )

				currentSetNumber=$(echo $currentLineString | awk -v curset="$currentSet" -F "${i}" '{gsub(" ","'${i}'"); print $curset}')

				checkedSetNumber=$currentSetNumber

				echo "IN  $checkedSetNumber"

				for j in 'F' 'E' 'S' 'T' 'H' 'M' ; do

					checkedSetNumberTemp=`contains $currentSetNumber $j`

					echo "out1 :$checkedSetNumberTemp"


					if [[ -z $checkedSetNumberTemp ]]; then
						checkedSetNumber=""
					fi

					echo "out2 :$checkedSetNumber"

				done

				if [[ -n $checkedSetNumber ]]; then
				
					checkedSetNumberFloat=`isVariableFloat $checkedSetNumber`

					checkedSetNumberInteger=`isVariableInteger $checkedSetNumber`

					if [[ -z $checkedSetNumberFloat && -z $checkedSetNumberInteger ]]; then

						checkedSetNumber=""
					fi
				fi

				echo "out3 :$checkedSetNumber"


				if [[ -n $checkedSetNumber ]]; then
					
					echo "Out  :$currentSetNumber"
					#resultNumber="`expr $resultNumber + $currentSetNumber`"

					#resultNumber=$(echo $resultNumber $currentSetNumber | awk '{print $1 + $2}')

					resultNumber=$(echo "$resultNumber + $currentSetNumber" | bc)

				fi

			done

			if [[ "${tempNumber}" == "${resultNumber}" ]]; then

				currentSet=""

			else

				currentSet="`expr $currentSet + $increaseNumber`"

			fi

			tempNumber=$resultNumber

		done

		echo "Temp :$resultNumber"

	else

		exitCheckString="`expr $exitCheckString - $increaseNumber`"

		if [[ $exitCheckString == "0" ]]; then
			echo "Result >>> $resultNumber"

			exit 0
		fi

	fi


	currentLineNumber="`expr $currentLineNumber + $increaseNumber`"

done


echo "Result >>> $resultNumber"


