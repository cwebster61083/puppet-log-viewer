# puppet-log-viewer

Puppet Log Viewer is a project for standing up an [ELK](https://www.elastic.co/what-is/elk-stack) stack in Docker and shipping Puppet support script logs for analysis.

It utlizes the [docker-elk](https://github.com/deviantony/docker-elk) for creating the three Docker containers that compoise a dasic [ELK](https://www.elastic.co/what-is/elk-stack) stack. For addtional documentation please refer to [Elastic_Stack_on_Docker.md](Elastic_Stack_on_Docker.md) for additional details.

## Installation

- Verify that [Docker](https://www.docker.com/) is installed. This can be done by running `docker --version`.

- Verify that [Docker Compose](https://docs.docker.com/compose/) is installed. This can be done by running `docker-compose --version`

- Verify that [Git](https://git-scm.com/) is installed. This can be done by running `git --version`

- Clone this project to your local workstation with the following.

```bash
git clone https://github.com/cwebster61083/puppet-log-viewer.git
```

## Usage

To use this tool run `view-in-kibana.sh` passing it the directory containing the log files to be loaded.

For example:

```bash
./view-in-kibana.sh ~/Downloads/puppet_enterprise_support/
```

You can then view the kibana dashboard by visiting `http://localhost:5601` in a web browser.

- Username: `elastic`
- Password: `changeme`

Once you are finished run `docker-compose down --volumes` to destroy the environment.

## Logstash Filters

The configs files used by Logstash for filtering log files can be found in `./logstash/pipelines`

## Manualy Running Import

```
client_name='costco'
host_name='lappum01094p01'
destination='elastic.puppetdebug.vlan'
port='5000'

files=$(gfind ./ -regextype sed -regex '.*logs.*puppetserver.log' -o -regex '.*logs.*puppetserver-[0-9].*[gz]')

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

  echo "$read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port"
  $read_cmd $file | awk -v c=$client_name -v h=$host_name '$1 = $1 FS c FS h' | nc $destination $port

done
```

## Checking existing indexes:

```bash
elastic_host="10.234.5.168"
curl -XGET "http://$elastic_host:9200/_cat/indices"
```

## Delete an index

```
elastic_host="10.234.5.168"
client_index="client-duke-energy-2021.01.07"
curl -X DELETE "$elastic_host:9200/$client_index?pretty"
```