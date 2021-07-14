directory='/Users/chris.webster/repos/tickets/42599/puppet_enterprise_support_42599_iaasn00007757_20210107093759/'
client_name='jpmc'
host_name='iaasn00007757.svr.us.jpmchase.net'
destination='elastic.puppetdebug.vlan'
port='5000'

function usage() {
  echo "Usage: $(basename $0) [-c][-d]" 2>&1
  echo '       -c  sets client name'
  echo '       -d  sets the destination for logs to be sent'
  exit 1
}

if [[ ${#} -eq 0 ]]; then
   usage
fi

# list of arguments expected in the input
optstring=":abcd"

while getopts ${optstring} arg; do
  case ${arg} in
    a)
      echo "showing usage!"
      usage
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 2
      ;;
  esac
done

function ship_logs(){
  files=$(gfind $directory -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]')

  for file in $files; do
      printf 'Processing: %s\n' "${file}" >&2

      case "$(basename "${file}")" in
        *.gz)
          read_cmd='gunzip -c'
          ;;
        *.log)
          read_cmd='cat'
          ;;
      esac

    #echo "Command: $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port"
    $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port

  done
}
