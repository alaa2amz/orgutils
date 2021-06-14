d='\x2d'
us='\x5f'
while getopts e:v:p: opt;do
	case $opt in
		e)
		e=$OPTARG
		;;
		v)
		v=$OPTARG
		;;
		p)
		p=$OPTARG
		;;
	esac
done
shift `expr $OPTIND - 1`

prefix=${p:-""}
viewer=${v:-xdg-open}
editor=${e:-vi}
draft=$(tempfile)
logfile=$(tempfile)

killall  $viewer
for f in "$@";do
	printf "\n%s" "$(basename "$f")" > $draft
$viewer "$f" 2>/dev/null&
pid=$!
$editor $draft
ii=$(cat $draft|tr '\n' '.' |sed 's/[^[:alnum:].,]/_/g'|sed 's/_*\._*/./g'|sed -E 's/^[\._]|[\._]$//g'|tr '[:upper:]' '[:lower:]'|tr -s '._')
dirname=$(dirname "$f")

if [ "$prefix" != "" ];then
	mkdir $dirname/$prefix
	dirname="$dirname/$prefix"
fi
echo -e "$counter / $# mv $f
--to--
\x1b[31m$dirname/$ii\x1b[m ??"
read ok
case $ok in
	[yY]*)
		mv -iv "$f" "$dirname/$ii" 2>&1|tee -a "$0"-log.txt; date >> "$0"-log.txt ;echo '-----' >>"$0"-log.txt
		;;	
	#e*) 

esac

kill $pid
counter=$(($counter+1))
done
