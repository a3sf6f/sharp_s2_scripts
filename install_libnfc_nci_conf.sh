#!/bin/sh
#
# See https://github.com/a3sf6f/sharp_s2_treble_vendor_image/blob/adapt_for_aosp90/contrib/README.md
#


if [ $# -lt 1 ]; then
	echo "Usage: `basename $0` MOUNTED_IMG_DIR"
	exit 1
fi

if [ `id -u` -ne 0 ]; then
	echo "`basename $0` requires ROOT to set required attributes."
	echo "Try invoke with sudo."
	exit 1
fi

dest_dir=$(readlink -f $1)

base=$(dirname $(readlink -f $0))
src_dir=$base/contrib/

install -pv -m 00644 -o 0 -g 0 -t $dest_dir/system/phh $src_dir/libnfc-nci-oreo.conf
setfilecon u:object_r:system_file:s0 $dest_dir/system/phh/libnfc-nci-oreo.conf
