# Setup Jenkins

## build vm
`docker build -t kaltepeter/jenkins:v2 .`

## start vm
`docker run --name jenkins-custom -p 8085:8080 -p 2222:22 -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -u root:root -v ~/data/jenkins_home:/var/jenkins_home kaltepeter/jenkins:v2`

## start jenkins
`docker exec -i -t jenkins-custom bash`
`/usr/local/bin/jenkins.sh`

## push code to machine
`git remote add local2 ssh://docker@192.168.99.101:2222/opt/git/test-automation.git`

`git push local2 master`

## troubleshooting

#### fix network
`docker-machine restart default`

`eval $(docker-machine env default)`

#### TODO
copy ~/data/jenkins_home to ./jenkins_home