#!/bin/sh
#
# Show the canonical package name for all apks.
#
if [ $# -lt 1 ]; then
	echo "Usage: `basename $0` MOUNTED_IMG_DIR"
	exit 1
fi

dest_dir=$(readlink -f $1)

find $dest_dir/system/ -type f -iname "*.apk" -printf "%P " \
	-exec sh -c "aapt dump badging {} | sed -nr \"s/^package: name='([^']+)'.*/\1/p\"" \; 2>/dev/null \
	| awk '{print $2 "  " $1}' \
	| LC_ALL=C sort -u
