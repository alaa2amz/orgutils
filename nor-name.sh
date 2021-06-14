#convert any puntuation mark to dot except - or space
#for keeep the forer and convert the later to -
#and the rest to dot(.) to be converted
#delete initial or last dot if found
for i in "$@"
do
	ii=$(printf %s "$i" |sed 's/[^[:alnum:] -_]/./g;s/[ _]/-/g'|sed -E 's/^\.|\.$//g'|tr '[:upper:]' '[:lower:]'|tr -s '.-')
	echo move $i to $ii??
	read answer
done
