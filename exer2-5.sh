#!/bin/bash
# This script is used to display your home directory and terminal type that you
# are using. Additionally it shows all the services started up in runlevel 3 on
# your system.

echo
# display home directory and terminal type
echo "Your home directory is $HOME and terminal is $TERM"
echo

echo
echo "Services started up in runlevel 3 are:"

set -x                                 # activate debugging

# display the services started up in runlevel 3
#   1. use ls command to list the services started up in runlevel 3,
#   2. find the service's path by awk (all files in /etc/rc3.d/ are links)
#   3. use basename command show service's name
basename -a $(ls -l /etc/rc3.d/S* | awk '{print $NF}')

set +x                                 # disable debugging

echo
