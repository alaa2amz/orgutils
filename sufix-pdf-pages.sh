#pdfinfo "$f"|grep Pages|grep -o '[0-9]*'

for f in "$@";do
	pc=$(pdfinfo "$f"|grep Pages|grep -o '[0-9]*')
	echo $pc
	ff=$(printf "$f"|sed 's/.pdf$/.p'"$pc"'.pdf/')
	echo $ff
	mv -iv "$f" "$ff"
done

