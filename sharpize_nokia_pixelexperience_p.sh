#!/bin/sh
#
# rom_website: https://forum.xda-developers.com/nokia-7-plus/development/9-0-pixelexperience-p-unofficial-t3885225
# rom_updated_at: 2019-01-24
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

#
# To eliminate "Your phone has an internal problem..." message,
# for a *release* build, should set
#
#     ro.build.fingerprint = ro.vendor.build.fingerprint
#
# however, the S2's fingerprint hasn't been verified in Android 9's GAPP,
# gapps complains and asks you to register your device.
#
# Just leaves it as a B2N there, and changes other props to SS2's, just in
# case some vendor scripts may use these properties.
#
# Note that treble sharp overlay detects "ro.product.board=SAT",
# which comes with a stock vendor image.
#
sed -ri '
	 s|^(ro.build.product=).*|\1SAT|
	 s|^(ro.product.brand=).*|\1SHARP|
	 s|^(ro.product.model=).*|\1FS8010|
	 s|^(ro.product.name=).*|\1FS8010_00WW|
	 s|^(ro.product.device=).*|\1SS2|
	 s|^(ro.product.manufacturer=).*|\1FIH|
' $dest_dir/system/build.prop

#
# Remove no-use apps
#
cd $dest_dir/system

rm -rf overlay/*-huawei*
rm -rf overlay/*-xiaomi*
rm -rf overlay/*-asus*
rm -rf overlay/*-lenovo*
rm -rf overlay/*-lg*
rm -rf overlay/*-moto*
rm -rf overlay/*-oneplus*
rm -rf overlay/treble-overlay-wifi5g.apk
rm -rf app/treble-overlay-oneplus*
rm -rf app/treble-overlay-samsung*
rm -rf app/treble-overlay-xiaomi*

rm -rf app/Roundapp app/ScreenRecorder
rm -rf overlay/*-nokia*
