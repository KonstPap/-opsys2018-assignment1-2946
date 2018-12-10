#!/bin/bash

#This program does all the wget at the same time but not uses them 
#v0.1

File=$1

#Checking to see if it's the first time running the script
file="previousrun.txt"
if [ -f "$file" ]
then
	#echo "$file found."
	a=1
else
	#echo "$file not found."
	touch previousrun.txt
	a=0
fi
#Removes comment lines from the given file
sed -i '/^#/d' $File
cat $File | xargs -n 1 -P 100 wget  &>/dev/null
#Reading File checking 
while read -r Line; do
#for i in {1..wc -l File}; do
	#cat $File | awk "NR==$i"
	##sed -n  $c < $File

#done	
	str=$Line

	#Checks if the content of each line exist at the "file"
	name=${Line///}
	if grep -Fxq "$str" $file
	then
		#Old url found
		a=0
		touch currenturl
		name1=currenturl
		#Cheking if the file has changed
		new= wget -q -O $name1 $Line
		change= cmp --quiet $name $name1
		if [[ $change == 0 ]]; then 
			echo $Line
		fi
		cat $name1 >> $name
	else
		#New url found
		a=1
		wget -q -O $name $Line
		if [[ -s $name ]]; then
			echo "$str INIT"
		else
			echo "$str FAILED"
		fi
		#Put the new url to the previousfile
		echo $Line >> $file
			
	fi
	

#done
done < $File







