#!/usr/bin/env bash

type=$2
line=$1

case $type in
	t1)
		for(( l=0;l<"$line";l++ ));do
			for(( s=0; s<$line-l-1;s++ ));do
				echo -n " "
			done
			for((j=0; j < l+1 ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
	t2)
		
		for(( l=0;l<"$line";l++ ));do
			for((j=0; j < l+1 ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
	t3)
		
		for(( l=0;l<"$line";l++ ));do
			for(( s=0; s<$line-l-1;s++ ));do
				echo -n " "
			done
			for((j=0; j < (l+1)+(l+1)-1 ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
	t4)
			
		for(( l=0;l<"$line";l++ ));do
			for((j=0; j < $line-l ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
	t5)
		
		for(( l=0;l<"$line";l++ ));do
			for(( s=0; s<l+1;s++ ));do
				echo -n " "
			done
			for((j=0; j < $line-l ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
	t6)
		
		for(( l=0;l<"$line";l++ ));do
			for(( s=0; s<l+1;s++ ));do
				echo -n " "
			done
			for((j=0; j < ($line-l)+($line-l)-1 ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
	t7)
		
		for(( l=0;l<"$line";l++ ));do
			for(( s=0; s<$line-l-1;s++ ));do
				echo -n " "
			done
			for((j=0; j < (l+1)+(l+1)-1 ;j++));do
				echo -n "*"
			done
			echo ""
		done
		temp_line=$((line-1))
		for(( l=0;l<"$temp_line";l++ ));do
			for(( s=0; s<l+1;s++ ));do
				echo -n " "
			done
			for((j=0; j < ($temp_line-l)+($temp_line-l)-1 ;j++));do
				echo -n "*"
			done
			echo ""
		done
		;;
esac
