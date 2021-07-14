# !/bin/bash -x

pattern='-regex ".*logs.*puppetserver.log" -o -regex ".*logs.*puppetserver-[0-9].*[gz]"'
source_directory="/Users/chris.webster/repos/tickets/41223/puppet_enterprise_support_41223_puppet-master_20201021234416"

command="gfind $source_directory -regextype sed $pattern"

$command





# pattern='-regextype posix-extended -type f -name puppetserver.log -o -name "puppetserver-[[:digit:]]*.*gz"'
# source_directory="/Users/chris.webster/repos/tickets/41223/puppet_enterprise_support_41223_puppet-master_20201021234416"

# # gfind $source_directory  "${pattern}"

# gfind $source_directory $pattern

# pattern='-regextype posix-extended -type f -name puppetserver.log -o -name "puppetserver-[[:digit:]]*.*gz"'

# gfind $source_directory $pattern