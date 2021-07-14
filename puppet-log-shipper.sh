#!/bin/bash

function usage() {
  echo "Usage: $(basename $0) [-c][-d]" 2>&1
  echo '       -c  sets client name'
  echo '       -d  sets the destination for logs to be sent'
  exit 1
}

function validate_directory_parameter(){
  echo "source = $source_directory"
  [[ ! -d $source_directory ]] && { echo "ERROR: First argument must be a directory."; usage; exit 1; }
}

if [[ ${#} -eq 0 ]]; then
   usage
fi

while getopts ":c:d:" arg; do
  case $arg in
    c)
      client_name="$OPTARG"
      echo "You specified client name $client_name."
      ;;
    d)
      destination=$OPTARG
      echo "You specified an address of $destination."
      ;;
    :)
      echo "$0: Must supply an argument to -$OPTARG." >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done
shift "$((OPTIND-1))"

source_directory=$1
# datadir="$(cd "$1" || exit; echo "$PWD")"

validate_directory_parameter $source_directory

function search_logs(){
  gfind $source_directory -regextype sed $1
}

function ship_logs(){
  pattern=$1
  port=$2

  echo "Destination is $destination"
  echo "Port = $port"
  for file in $(search_logs "$pattern"); do
    printf 'Processing: %s\n' "${file}" >&2

    case "$(basename "${file}")" in
      *.gz)
        read_cmd='gunzip -c'
        ;;
      *.log)
        read_cmd='cat'
        ;;
    esac
    
    # $read_cmd "${file}" | nc $DESTINATION $PORT

    # $read_cmd "${file}" | awk -v c=$client_name -v h=$(cat "$source_directory/networking/hostname_output.txt") '{printf "%s", $1}; {printf "\s"}; {for(i=2;i<=NF;i++){printf "%s ", $i}; printf "\n"}'

    # awk="awk '{ print "$client_name", "host_name", \$0 }'"
    # echo "awk = $awk"
    # $read_cmd "${file}" | $awk
    # $read_cmd "${file}" | awk -v c=$client_name -v h=$(cat "$source_directory/networking/hostname_output.txt") '{ print $1, c, h, $2-NF }'
    # $read_cmd "${file}" | awk -v c=$client_name -v h=$(cat "$source_directory/networking/hostname_output.txt") '{ for ( i=2; i<=NF; i++) {print $1} ; {printf $i " "} ; printf "\n"}'

    $read_cmd "${file}" | awk -v c=$client_name -v h=$(cat "$source_directory/networking/hostname_output.txt") '$1 = $1 FS c FS h' | nc $destination $port

  done
}

ship_logs '-regex .*logs.*puppetserver.log -o -regex .*logs.*puppetserver-[0-9].*[gz]' 5000
# ship_logs '-regex .*puppetserver.*puppetserver-[0-9].*[gz]' 5000

# ship_logs '-regex .*logs.*console-services-access.log -o -regex .*logs.*console-services-access-[0-9].*[gz]' 5001
# ship_logs '-regex .*logs.*puppetserver-access.log -o -regex .*logs.*puppetserver-access-[0-9].*[gz]' 5002


# function puppetserver_logs(){
#   pattern='-regex .*logs.*puppetserver.log -o -regex .*logs.*puppetserver-[0-9].*[gz]'
#   port=5000
#   ship_logs "$pattern" "$port"
# }

# pattern='-regex ".*logs.*puppetserver.log" -o -regex ".*logs.*puppetserver-[0-9].*[gz]"'
# source_directory="/Users/chris.webster/repos/tickets/41223/puppet_enterprise_support_41223_puppet-master_20201021234416"

# command="gfind $source_directory -regextype sed $pattern"

# $command
# ship_logs "\( -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]' \)" 5000
# ship_logs "*console-services-api-access*" 5001

# function ship_logs(){

# }


# #Puppet console-services-api-access logs.
# logstash_host="10.234.5.168"
# port="5001"
# pattern="*console-services-api-access.log"
# datadir="$(cd "$1" || exit; echo "$PWD")"
# find "$datadir" -name $pattern -print0 | xargs -0 cat | nc $logstash_host $port



# gfind /Users/chris.webster/repos/tickets/41223/puppet_enterprise_support_41223_puppet-master_20201021234416 -regextype sed \( -regex ".*logs.*puppetserver.log" -o -regex ".*logs.*puppetserver-[0-9].*[gz]" \)

# gfind /Users/chris.webster/repos/tickets/41223/puppet_enterprise_support_41223_puppet-master_20201021234416 -regextype sed '\( -regex ".*logs.*puppetserver.log" -o -regex ".*logs.*puppetserver-[0-9].*[gz]" \)'




