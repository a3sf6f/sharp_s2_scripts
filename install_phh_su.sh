#!/bin/sh
#
# Install su and superuser to *phh* treble-based system image,
# for which the **phh customized selinux policies** had been set.
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
src_dir=$base/contrib/phhusson

#
# Perms, modes, labels are referenced from AOSP 9 v110 GSI.
#
# https://github.com/phhusson/treble_experimentations/releases/tag/v110
# https://github.com/phhusson/treble_experimentations/commit/0e47893cf3a7791868a5f9cb56d76e6389393a30
#
install -pv -m 00755 -o 0 -g 2000 -t $dest_dir/system/bin $src_dir/phh-su
install -pv -m 00755 -o 0 -g 2000 -d $dest_dir/system/xbin
install -pv -m 04750 -o 0 -g 2000 -t $dest_dir/system/xbin $src_dir/su
install -pv -m 00644 -o 0 -g 0 -t $dest_dir/system/etc/init $src_dir/su.rc
install -pv -m 00755 -o 0 -g 0 -d $dest_dir/system/app/me.phh.superuser
install -pv -m 00644 -o 0 -g 0 -t $dest_dir/system/app/me.phh.superuser $src_dir/me.phh.superuser.apk

setfilecon u:object_r:phhsu_exec:s0	$dest_dir/system/bin/phh-su
setfilecon u:object_r:system_file:s0	$dest_dir/system/etc/init/su.rc
setfilecon u:object_r:system_file:s0	$dest_dir/system/xbin
setfilecon u:object_r:su_exec:s0	$dest_dir/system/xbin/su
setfilecon u:object_r:system_file:s0	$dest_dir/system/app/me.phh.superuser
setfilecon u:object_r:system_file:s0	$dest_dir/system/app/me.phh.superuser/me.phh.superuser.apk
