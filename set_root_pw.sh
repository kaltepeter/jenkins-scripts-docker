#!/bin/bash

if [ -z "${SSH_KEY}" ]; then
	echo "=> Please pass your public key in the SSH_KEY environment variable"
#	exit 1
fi

for MYHOME in /var/jenkins_home /home/docker /home/git; do
	echo "=> Adding SSH key to ${MYHOME}"
	mkdir -p ${MYHOME}/.ssh
	chmod go-rwx ${MYHOME}/.ssh
	echo "${SSH_KEY}" > ${MYHOME}/.ssh/authorized_keys
	chmod go-rw ${MYHOME}/.ssh/authorized_keys
	echo "=> Done!"
done
chown -Rf docker:docker /home/docker/.ssh
echo $cip
cat ~/.ssh/id_rsa.pub | ssh -p 2222 root@$cip "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"

echo "========================================================================"
echo "You can now connect to this container via SSH using:"
echo ""
echo "    ssh -p <port> <user>@<host>"
echo ""
echo "Choose root (full access) or docker (limited user account) as <user>."
echo "========================================================================"