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

while [ : ];do 
	$editor $draft
	ii=$(cat $draft|tr '\n' '.' |sed 's/[^[:alnum:].,]/_/g'|sed 's/_*\._*/./g'|sed -E 's/^[\._]|[\._]$//g'|tr '[:upper:]' '[:lower:]'|tr -s '._')
	dirname=$(dirname "$f")

	if [ "$prefix" != "" ];then
		mkdir -p $dirname/$prefix
		dirname="$dirname/$prefix"
	fi
	tput clear;
	echo -e "\x1b[33m${counter:=1} / $# \x1b[m
mv 
$f
--to--
\x1b[31m$dirname/\n\x1b[32m$ii\x1b[m ??
-----------------------------
y:proceed  e:reedit  x:exit
anything else to skip
-----------------------------"|fold -w60

	read ok

	case $ok in
		y)
		mv -iv "$f" "$dirname/$ii" 2>&1|tee -a "$0"-log.txt; date >> "$0"-log.txt ;echo '-----' >>"$0"-log.txt;break
		;;	
		e) continue ;;
		x) kill $pid;exit;;
		*)break;;
	esac
done

kill $pid
counter=$(($counter+1))
done
