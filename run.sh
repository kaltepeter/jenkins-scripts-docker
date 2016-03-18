#!/bin/bash

set -e

/set_root_pw.sh
echo "starting sshd....."
/usr/sbin/sshd
/bin/bash