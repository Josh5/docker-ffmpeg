###
# File: 10_download.sh
# Project: LIBDRM
# File Created: Wednesday, 9th June 2021 12:39:13 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:40:23 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing libdrm (${LIBDRM}) ****"
mkdir -p /tmp/libdrm

curl -Lf \
    https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM}.tar.xz -o /tmp/libdrm-${LIBDRM}.tar.xz

tar xf /tmp/libdrm-${LIBDRM}.tar.xz --strip-components=1 -C /tmp/libdrm
[[ $? -gt 0 ]] && exit 1

rm /tmp/libdrm-${LIBDRM}.tar.xz
