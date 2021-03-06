#!/bin/bash

# Daemon fix
my_path="$(dirname $0)"
cd "$my_path"

# Include configs and functions
source config.sh

# Incoming argv count test
if [ $# -lt 2 ]
then
 echo "./script <mode> <count>"
 exit
fi

x=1         # For increment
mode=$1     # Filename mask
keep=$2     # Exclude latest {count} files

#
# Stage 1 - Select values by mode
#
case $mode in
    "deb")
        path="$REPO_DEB"
        filemask1="*client_*.deb"
        filemask2="*client-nls_*.deb"
        ;;
    "rpm")
        path="$REPO_RPM"
        filemask1="*client-8*.rpm"
        filemask2="*client-nls-*.rpm"
        ;;
    *)
        echo "ERR: Wrong mode, only 'deb' or 'rpm' is available"
        exit
        ;;
esac

#
# Stage 2 - Remove the old files
#
ls -t $path/$filemask1 | \
while read filename
    do
        if [ $x -le $keep ]; then x=$(($x+1)); continue; fi
        echo "INF: Removing $filename"
        rm "$filename"
done

ls -t $path/$filemask2 | \
while read filename
    do
        if [ $x -le $keep ]; then x=$(($x+1)); continue; fi
        echo "INF: Removing $filename"
        rm "$filename"
done
