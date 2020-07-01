# puppet-log-viewer

Puppet Log Viewer is project for standing up an [ELK](https://www.elastic.co/what-is/elk-stack) stack in Docker and shipping Puppet support script logs for analysis.

It utlizes the [docker-elk](https://github.com/deviantony/docker-elk) for creating the three Docker containers that compoise a dasic [ELK](https://www.elastic.co/what-is/elk-stack) stack. For addtional documentation please refer to [Elastic_Stack_on_Docker.md](Elastic_Stack_on_Docker.md) for additional details.

## Installation

- Verify that [Docker](https://www.docker.com/) is installed. This can be done by running `docker --version`.

- Verify that [Docker Compose](https://docs.docker.com/compose/) is installed. This can be done by running `docker-compose --version`

- Verify that [Git](https://git-scm.com/) is installed. This can be done by running `git --version`

- Clone this project to your local workstation with the following.

``` shell
git clone https://github.com/cwebster61083/puppet-log-viewer.git
```

## Usage

To use this tool run `view-in-kibana.sh` passing it the directory containing the log files to be loaded.

For example:

```
./view-in-kibana.sh ~/Downloads/puppet_enterprise_support/
```

You can then view the kibana dashboard by visiting `http://localhost:5601` in a web browser.

- Username: `elastic`
- Password: `changeme`

Once your are finished run `docker-compose down --volumes` to destroy the environment.

## Logstash Filters

The configs files used by logstash for filtering log files can be found in `./logstash/pipelines`
