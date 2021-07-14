# puppet-log-shipper

## Purpose: To start some tool on the local system to ship Puppet Server logs to an elasticsearch host. 

### This script should do the following.

- Take the following input parameters
  - Directory location of the logs to be imported
  - If supporting multiple tools then allow the tool to be specified. For example (netcat, logstash, filebeat)
  - Destination to ship logs to
    - IP or hostname of elasticsearch database
    - Index name
    - Option to overwrite any index that already exsists
- Check that the tool passed is installed
- Check that the directory specifed is present
- Check if the destination already exsists
- Build the config for the specific tool being used
- Preform and data transformations or operation on logs as requried
- Run the tool specifed with the dynamicly created configuration file