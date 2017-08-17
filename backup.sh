#!/bin/bash

# backup.sh
# This script makes a backup of my home directory.

# Change the values of the variables to make the script work for you:
BACKUPDIR=/home
BACKUPFILES=japin
TARFILE=/var/tmp/home_japin.tar
BZIPFILE=/var/tmp/home_japin.tar.bz2
SERVER=10.9.5.32
REMOTEDIR=/opt/backup/japin
LOGFILE=/home/japin/log/home_backup.log

cd $BACKUPDIR

# This creates the archive
tar cf $TARFILE $BACKUPFILES > /dev/null 2>&1

# First remove the old bzip2 file. Redirect errors because this generates
# some if the archive does not exist. Then create a new compressed file.
rm $BZIPFILE 2> /dev/null
bzip2 $TARFILE

# Copy the file to another host - we have ssh keys for making this work
# without intervention.
# For larger directories and lower bandwidth, use rsync to keep the directories
# at both ends synchronized.
scp $BZIPFILE $SERVER:$REMOTEDIR > /dev/null 2>&1

# Create a timestamp in a logfile.
data >> $LOGFILE
echo backup succeeded >> $LOGFILE
