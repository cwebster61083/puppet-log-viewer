#cat ./puppetserver.log | nc localhost 5000  

datadir="$(cd "$1" || exit; echo "$PWD")"

echo $datadir

find "$datadir" -name "*puppetserver.log" -print0 | xargs cat | nc localhost 5000