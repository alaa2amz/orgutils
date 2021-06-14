#!/bin/sh
##prune-backup##

#v:bp:backup pattern
#v:n:name
#v:b:backu extension

bp='([^~]*)([~0-9]*~)$'
for i in "$@"
do
	case "$i" in
	*\~)
		n=`echo $i|sed -E "s/$bp/\1/"|sed 's/\.$//'`
		b=`echo $i|sed -E "s/$bp/\2/"|sed 's/^\.//'`
		mv -Tvi "$i" "$b$n"
		;;

esac
done
