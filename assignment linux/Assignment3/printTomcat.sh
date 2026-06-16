#!/usr/bin/env bash

number=$1

if [[ -z "$number" ]];then
	echo "Usage: $0 <number>"
	exit 1
fi

if (($number%15==0));then
	echo "tomcat"
elif (($number%5==0));then
	echo "cat"
elif (("$number"%3==0));then
	echo "tom"
else 
	echo "$number"
fi
