#!/bin/bash

set -e

/set_root_pw.sh
exec /usr/sbin/sshd -D
su jenkins
sh /usr/local/bin/jenkins.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
source ~/.bashrc