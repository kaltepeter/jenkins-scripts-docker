# Setup Jenkins

## setup docker with proxy
You must recreate the default machine or another to support proxies. 
`sh create_machine_proxy.sh -c username:password -p proxy:proxyport`

if docker login can't connect:
re-run
	docker-machine env --no-proxy default
	eval $(docker-machine env --no-proxy default)

## pull vm
docker pull kaltepeter/jenkins

## build vm (if building locally)
`docker build -t kaltepeter/jenkins .`

with proxy:
sed 's/^M$//' plugins.txt > plugins.txt

	proxy=http://username:password@proxy:proxyport && \
	docker build \
	--build-arg HTTP_PROXY=$proxy \
	--build-arg http_proxy=$proxy \
	--build-arg HTTPS_PROXY=$proxy \
	--build-arg https_proxy=$proxy \
	--build-arg NO_PROXY=$(docker-machine ip) \
	--build-arg no_proxy$(docker-machine ip) \
	-t kaltepeter/jenkins .

## start vm
`docker run --name jenkins-custom -p 8085:8080 -p 2222:22 -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -u root:root -v ~/data/jenkins_home:/var/jenkins_home kaltepeter/jenkins:v2`

## start jenkins
`docker exec -i -u jenkins:jenkins -t jenkins-custom /usr/local/bin/jenkins.sh`

## push code to machine
`git remote add local2 ssh://docker@192.168.99.101:2222/opt/git/test-automation.git`

`git push local2 master`

## troubleshooting

#### fix network
`docker-machine restart default`

`eval $(docker-machine env default)`

#### fix windows docker-machine with proxy issues
http://www.netinstructions.com/how-to-install-docker-on-windows-behind-a-proxy/

#### TODO
copy ~/data/jenkins_home to ./jenkins_home