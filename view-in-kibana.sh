function usage() {
  cat <<EOF
USAGE: view-in-kibana.sh <options> [directory]
EOF
}

function validate_directory_parameter(){
  [[ ! -d $SOURCE_DIRECTORY ]] && { echo "ERROR: First argument must be a directory."; usage; exit 1; }
}

function validate_dockor_compose_installed() {
  type docker-compose &>/dev/null || {
  echo "ERROR: docker-compose required. Please install docker-compose."
  exit 1
 }
}

function get_latest_containers() {
  echo "Getting the latest container images"
  echo "Downloading latest containers"
  docker-compose pull --ignore-pull-failures || { exit 1; }
}

function start_docker_containers() {
  echo "Starting Containers"
  docker-compose up -d || { exit 1; }
}

function validate_elasticsearch_up() {
  echo "Waiting for elasticsearch to be ready..."
  timeout=60
  until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:9200 -u elastic:changeme) || (( timeout <= 0)); do
    (( timeout-- ))
    printf '.'
    sleep 5
  done
    (( timeout <=0 )) && {
      echo "ERROR: Unable to connect to the elasticsearch. Is docker running?"
      exit 1
    }
  echo "Elastic Search Ready"
  curl -X GET "http://localhost:9200" -u elastic:changeme
}

function validate_logstash_up() {
  echo "Waiting for Logstash to be ready..."
  timeout=60
  until nc -zv 127.0.0.1 5000 &>/dev/null || (( timeout <= 0 )); do
    (( timeout-- ))
    sleep 5
  done
    (( timeout <= 0 )) && {
      echo "ERROR: Unable to connect to the logstash. Is docker running?"
      exit 1
  }
  echo "Logstash Ready"
}

function validate_kibana_up() {
  echo ""
  echo "Waiting for Kibana to be ready..."
  echo ""
  sleep 30
  timeout=60
  until $(curl --output /dev/null --silent --head --fail http://127.0.0.1:5601/status -u elastic:changeme) || (( timeout <= 0)); do
    (( timeout-- ))
    printf '.'
    sleep 5
  done
    (( timeout <=0 )) && {
      echo "ERROR: Unable to connect to the Kibana. Is docker running?"
      exit 1
    }
}

function create_logstash_index() {
  echo ""
  echo "Creating Logstash index."
  echo ""
  sleep 10
  curl -XPOST 'http://localhost:5601/api/saved_objects/index-pattern' \
    -H 'Content-Type: application/json' \
    -H 'kbn-version: 7.6.0' \
    -u elastic:changeme \
    -d '{"attributes":{"title":"logstash-*","timeFieldName":"timestamp"}}'
}

function create_dashboard(){
  echo ""
  echo "Creating Dashboard..."
  echo ""
  sleep 10
  curl -XPOST 'localhost:5601/api/saved_objects/_import' \
    -H 'kbn-xsrf: true' \
    -u elastic:changeme \
    --form file=@dashboards/dashboard.ndjson
  echo ""
  echo "Puppet Server Dashboard: http://127.0.0.1:5601/app/kibana#/dashboard/751cdd20-58cc-11ea-baf6-a3aaaa7b3fdb?_g=(filters%3A!()%2CrefreshInterval%3A(pause%3A!t%2Cvalue%3A0)%2Ctime%3A(from%3Anow%2Fw%2Cto%3Anow%2Fw))"
}

function load_logs_puppetserver() {
  echo ""
  echo "Loading Puppet Server Logs..."
  echo "Sleeping for 10 seconds."
  sleep 10
  echo $datadir
  echo ""
  find "$datadir" -name "*puppetserver.log" -print0 | xargs -0 cat | nc localhost 5000
}

function load_logs_console_service_api_access() {
  echo ""
  echo "Loading Console Services API Access Logs..."
  echo "Sleeping for 10 seconds."
  sleep 10
  echo $datadir
  echo ""
  find "$datadir" -name "*console-services-api-access.log" -print0 | xargs -0 cat | nc localhost 5001
}

function load_logs_puppet_server_access() {
  echo ""
  echo "Loading Puppet Server Access Logs..."
  echo "Sleeping for 10 seconds."
  sleep 10
  echo $datadir
  echo ""
  find "$datadir" -name "*puppetserver-access.log" -print0 | xargs -0 cat | nc localhost 5002
}

function load_logs_puppetdb_access() {
  echo ""
  echo "Loading PuppetDB Access Logs..."
  echo "Sleeping for 10 seconds."
  sleep 10
  echo $datadir
  echo ""
  find "$datadir" -name "puppetdb-access.log" -print0 | xargs -0 cat | nc localhost 5003
}

function finish() {
  docker-compose down --volumes
}

SOURCE_DIRECTORY=$1
datadir="$(cd "$1" || exit; echo "$PWD")"

validate_directory_parameter $SOURCE_DIRECTORY

validate_dockor_compose_installed

#trap finish EXIT INT ERR

# From the end of the full path of this script, strip everything up to the first /
# i.e. `cd` to the directory containing this script
cd "${BASH_SOURCE[0]%/*}/${CONTAINERPATH}" || exit

get_latest_containers
start_docker_containers
validate_elasticsearch_up
validate_logstash_up
validate_kibana_up
create_logstash_index
create_dashboard

cat <<EOF

Elastic Search is ready! View at http://127.0.0.1:9200
Kibana dashboard is ready! View at http://127.0.0.1:5601

Username: elastic
Password: changeme

Press enter key to exit...
EOF

# load_logs_puppetserver
# load_logs_console_service_api_access
# load_logs_puppet_server_access
# load_logs_puppetdb_access

# Use _ as a throwaway variable
read -r _
