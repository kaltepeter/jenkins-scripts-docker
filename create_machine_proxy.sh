#!/bin/bash
credentials=
proxy=
while getopts ":c:p:" opt; do
  case $opt in
    c)
      credentials=$OPTARG
      ;;
    p)
      proxy=$OPTARG
      ;;
  esac
done

echo "using credentials $credentials and proxy $proxy"

docker-machine rm default
export http_proxy=http://$credentials@$proxy
export https_proxy=http://$credentials@$proxy
docker-machine create -d virtualbox \
      --engine-env HTTP_PROXY=http://$credentials@$proxy \
      --engine-env HTTPS_PROXY=http://$credentials@$proxy \
      default

echo "machine created as default"

echo "cat /var/lib/boot2docker/profile" > remote_command.sh
docker-machine ssh default < remote_command.sh

docker-machine env --no-proxy default
eval $(docker-machine env --no-proxy default)