# Puppet Server Logs

directory='/Users/chris.webster/repos/tickets/44229/puppet_enterprise_support_44229_cskpcloudxm1026_20210510132317/logs/puppetserver/'
client_name='kaiser'
host_name='cskpcloudxm1026.cloud.kp.org'
destination='elastic.puppetdebug.vlan'
port='5000'

# files=$(gfind $directory -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]')

for file in $(gfind $directory -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]'); do
    printf 'Processing: %s\n' "${file}" >&2

    case "$(basename "${file}")" in
      *.gz)
        gunzip -c $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port
        ;;
      *.log)
        cat $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port
        ;;
    esac

  # # echo "Command: $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port"
  # $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port

done

directory='/Users/chris.webster/repos/tickets/44229/puppet_enterprise_support_44229_cskpcloudxm1026_20210510132317/logs/puppetserver/'
client_name='kaiser'
host_name='cskpcloudxm1026.cloud.kp.org'
destination='elastic.puppetdebug.vlan'
port='5002'

# files=$(gfind $directory -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]')

for file in $(gfind $directory -regextype sed -regex '.*logs.*puppetserver-access.log' -o -regex '.*logs.*puppetserver-access-[0-9].*[gz]'); do
    #printf 'Processing: %s\n' "${file}" >&2

    case "$(basename "${file}")" in
      *.gz)
        # read_cmd='gunzip -c'
        gunzip -c $file | awk -v c=$client_name -v h=$host_name '{ print $0, c, h }' | nc $destination $port
        ;;
      *.log)
        # read_cmd='cat'
        cat $file | awk -v c=$client_name -v h=$host_name '{ print $0, c, h }' | nc $destination $port
        ;;
    esac

  # $read_cmd $file | awk -v c=$client_name -v h=$host_name '{ print $0, c, h }' 
done

# PuppetDB Logs
directory='/Users/chris.webster/repos/tickets/43078/puppetdb.log'
client_name='THD'
host_name='primary'
destination='elastic.puppetdebug.vlan'
port=''

# files=$(gfind $directory -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]')

for file in $(gfind $directory -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]'); do
    printf 'Processing: %s\n' "${file}" >&2

    case "$(basename "${file}")" in
      *.gz)
        gunzip -c $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port
        ;;
      *.log)
        cat $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port
        ;;
    esac

  # # echo "Command: $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port"
  # $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port

done