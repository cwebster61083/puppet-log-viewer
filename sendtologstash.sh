#cat ./puppetserver.log | nc localhost 5000  

datadir="$(cd "$1" || exit; echo "$PWD")"

echo $datadir

find "$datadir" -name "*puppetserver-access.log" -print0 | xargs -0 cat | nc localhost 5002
