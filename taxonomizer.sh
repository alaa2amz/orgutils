#!/bin/sh
#taxonomizer

for i in "$@"
do
	if [ -d "$i" ];then
	continue
	fi
	
	case   "$i" in
		*.*)
		
		ex="${i##*.}"
		if [ ! -d "$ex" ];then
		mkdir "$ex"
		fi
		mv -vi "$i" "$ex"/
		;;
	
		*)
		if [ ! -d andot ];then
  		mkdir andot
		fi
		mv -vi "$i" "andot/"
		;;
	esac


done
