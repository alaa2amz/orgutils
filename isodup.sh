#isolate duplicates in duplicates directory
#md5sum ./*|sort|uniq -D -w31
#md5sum z* |sort|uniq -D -w31|cut -d' ' -f2-|sed 's/^ //'

list=$(tempfile)
md5sum "$@" |sort |uniq -D -w31 > $list
mkdir dupdir
cat $list|cut -d' ' -f2-|sed 's/^ //'|while read i;do
mv -iv "$i" dupdir/
done

cat $list|uniq  -w31|cut -d' ' -f2-|while read i;do
mv -iv  dupdir/"$(basename $i)" "$(dirname $i)"
done


